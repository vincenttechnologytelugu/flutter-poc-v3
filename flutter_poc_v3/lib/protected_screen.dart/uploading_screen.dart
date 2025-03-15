import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

class UploadingScreen extends StatefulWidget {
  const UploadingScreen({Key? key}) : super(key: key);

  @override
  State<UploadingScreen> createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  Map<String, dynamic>? packageRules;
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  File? selectedVideo;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  // Add these to your existing variables
  bool _isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    // Force reload package rules when screen initializes
    // Force reload package rules when screen initializes

    _loadPackageRules();
    _checkSharedPrefs(); // Add this line to debug
  }

  Future<void> _checkSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    log('All SharedPreferences keys: $keys');
    keys.forEach((key) {
      log('Key: $key, Value: ${prefs.get(key)}');
    });
  }

  Future<void> _loadPackageRules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Force refresh SharedPreferences
      // First try to get rules from user_data which contains the active subscription rules
      final String? userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        final userData = json.decode(userDataString);
        final activeSubscriptionRules = userData['active_subscription_rules'];

        if (activeSubscriptionRules != null) {
          // Use the rules directly from user_data
          packageRules = {
            'image_attachments': activeSubscriptionRules['images'] ?? 2,
            'video_attachments': activeSubscriptionRules['video'] ?? 0,
            'post_count': activeSubscriptionRules['post_count'] ?? 1
          };
          log('Loaded package rules from user data: $packageRules');
        } else {
          // Fallback to default rules if active_subscription_rules is not found
          packageRules = {
            'image_attachments': 2,
            'video_attachments': 0,
            'post_count': 1
          };
          log('Using default package rules - no active subscription rules found');
        }
      } else {
        // Fallback to default rules if no user data is found
        packageRules = {
          'image_attachments': 2,
          'video_attachments': 0,
          'post_count': 1
        };
        log('Using default package rules - no user data found');
      }

      setState(() {});
    } catch (e) {
      log('Error loading package rules: $e');
      // Set default rules in case of error
      packageRules = {
        'image_attachments': 2,
        'video_attachments': 0,
        'post_count': 1
      };
      setState(() {});
    }
  }

// Add these functions in your _UploadingScreenState class

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getAdpostId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('adpostId'); // Getting adpostId with correct key
  }

  Future<bool> _validateFileSize(File file, bool isVideo) async {
    final int maxImageSize = 3 * 1024 * 1024; // 3 MB
    final int maxVideoSize = 20 * 1024 * 1024; // 20 MB

    final int fileSize = await file.length();
    if (isVideo && fileSize > maxVideoSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video size should be less than 20MB')),
      );
      return false;
    } else if (!isVideo && fileSize > maxImageSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image size should be less than 3MB')),
      );
      return false;
    }
    return true;
  }

// // Constants
//   final String IMAGE_ASSETS_KEY = 'image_assets';
//   final String VIDEO_ASSETS_KEY = 'video_assets';

  Future<void> uploadFile(File file, bool isVideo) async {
    try {
      // Validate file size
      bool isValidSize = await _validateFileSize(file, isVideo);
      if (!isValidSize) return;

      final token = await _getToken();
      final adpostId = await _getAdpostId();
      // Add debug log to check values
      log('Token: $token');
      log('AdpostId: $adpostId');

      if (token == null || adpostId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication or AdPost ID missing')),
        );
        return;
      }

      var uri = Uri.parse(
          'http://13.200.179.78/adposts/upload_file?adpostId=$adpostId');
      var request = http.MultipartRequest('POST', uri);

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Determine file type and create MultipartFile
      String fileName = file.path.split('/').last;
      String contentType;

      // Validate file type
      if (isVideo) {
        if (!fileName.toLowerCase().endsWith('.mp4')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Only MP4 videos are allowed')),
          );
          return;
        }
        contentType = 'video/mp4';
      } else {
        if (!fileName.toLowerCase().endsWith('.jpg') &&
            !fileName.toLowerCase().endsWith('.jpeg') &&
            !fileName.toLowerCase().endsWith('.png')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Only JPEG and PNG images are allowed')),
          );
          return;
        }
        contentType = fileName.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';
      }

      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(contentType),
      );

      request.files.add(multipartFile);

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploading ${isVideo ? 'video' : 'image'}...')),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        // // After successful upload, save the asset ID
        // String assetId = jsonResponse['data']['_id'];
  //  // Debug print for API response
  //     log('Upload Response Asset ID: $assetId');
        // Get file extension to determine if it's image or video
        String fileExtension = file.path.split('.').last.toLowerCase();
        bool isImage = ['jpg', 'jpeg', 'png'].contains(fileExtension);

        // Save the asset ID
      //   await _saveAssetId(assetId, isImage);
      //   // Print current assets after saving
      // checkCurrentAssets();
      // getSavedAssetIds() ;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful')),
        );
        log('Upload response: $jsonResponse');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'] ?? 'Upload failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
      log('Error uploading file: $e');
    }
  }

// Helper function to save asset IDs
//   Future<void> _saveAssetId(String assetId, bool isImage) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String key = isImage ? IMAGE_ASSETS_KEY : VIDEO_ASSETS_KEY;

//       // Get existing asset IDs
//       List<String> existingAssets = prefs.getStringList(key) ?? [];

//       // Add new asset ID
//       if (!existingAssets.contains(assetId)) {
//         existingAssets.add(assetId);
//         await prefs.setStringList(key, existingAssets);
//       }
//     } catch (e) {
//       log('Error saving asset ID: $e');
//     }
//   }

// // Function to get all saved asset IDs
//   Future<Map<String, List<String>>> getSavedAssetIds() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'images': prefs.getStringList(IMAGE_ASSETS_KEY) ?? [],
//       'videos': prefs.getStringList(VIDEO_ASSETS_KEY) ?? []
//     };
//   }

// Update pickImage function
  Future<void> pickImage() async {
    final int maxImages = packageRules?['image_attachments'] ?? 2;

    if (selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum image limit ($maxImages) reached')),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = File(image.path);
        // Upload the image first
        await uploadFile(imageFile, false);
        // If upload successful, add to local list
        setState(() {
          selectedImages.add(imageFile);
        });
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

// Update pickVideo function
  Future<void> pickVideo() async {
    final int maxVideos = packageRules?['video_attachments'] ?? 0;
    if (maxVideos == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video upload not allowed in your package')),
      );
      return;
    }

    if (selectedVideo != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum video limit reached')),
      );
      return;
    }

    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        setState(() {
          _isVideoLoading = true;
        });

        File videoFile = File(video.path);
        // Upload the video first
        await uploadFile(videoFile, true);

        await _disposeVideoControllers();

        _videoPlayerController = VideoPlayerController.file(videoFile);
        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          placeholder: Center(child: CircularProgressIndicator()),
        );

        setState(() {
          selectedVideo = videoFile;
          _isVideoLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isVideoLoading = false;
      });
      log('Error picking video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting video: $e')),
      );
    }
  }

  Future<void> _disposeVideoControllers() async {
    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController = null;
    }
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    super.dispose();
  }

  Widget _buildVideoPreview() {
    if (_isVideoLoading) {
      return Container(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (selectedVideo == null || _chewieController == null) {
      return Container(
        height: 80,
        width: 80,
        color: const Color.fromARGB(255, 235, 217, 217),
        child: const Center(
            child: Icon(
          Icons.video_library_rounded,
          color: Color.fromARGB(255, 244, 6, 38),
          size: 60,
        )),
      );
    }

    return Stack(
      children: [
        Container(
          height: 200,
          child: _chewieController != null
              ? Chewie(controller: _chewieController!)
              : Center(child: Text('Error loading video')),
        ),
        // Close icon to clear video
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () async {
                // Dispose controllers and clear video
                await _disposeVideoControllers();
                setState(() {
                  selectedVideo = null;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int maxImages = packageRules?['image_attachments'] ?? 2;
    final int maxVideos = packageRules?['video_attachments'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Media'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Package Limits:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Maximum Images: $maxImages'),
            Text('Maximum Videos: $maxVideos'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image (${selectedImages.length}/$maxImages)'),
            ),

            const SizedBox(height: 20),

            if (maxVideos > 0)
              ElevatedButton(
                onPressed: selectedVideo == null ? pickVideo : null,
                child:
                    Text('Pick Video ${selectedVideo != null ? '(1/1)' : ''}'),
              ),

            const SizedBox(height: 20),
            // Display saved assets count
            // FutureBuilder<Map<String, List<String>>>(
            //   future: getSavedAssetIds(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Column(
            //         children: [
            //           Text(
            //               'Images: ${snapshot.data!['images']?.length ?? 0}/4'),
            //           Text(
            //               'Videos: ${snapshot.data!['videos']?.length ?? 0}/1'),
            //         ],
            //       );
            //     }
            //     return SizedBox();
            //   },
            // ),

            // Display selected images
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Image.file(
                            selectedImages[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            left: 50,
                            bottom: 140,
                            child: IconButton(
                              icon: const Icon(Icons.delete_forever_rounded,
                                  color: Color.fromARGB(255, 11, 5, 5)),
                              onPressed: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            // // Display selected video
            // if (selectedVideo != null)
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Stack(
            //       children: [
            //         Container(
            //           height: 80,
            //           width: 80,
            //           color: Colors.grey[300],
            //           child: const Center(child: Text('Video')),
            //         ),
            //         Positioned(
            //           right: 0,
            //           top: 0,
            //           child: IconButton(
            //             icon: const Icon(Icons.close, color: Colors.red),
            //             onPressed: () {
            //               setState(() {
            //                 selectedVideo = null;
            //               });
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            _buildVideoPreview(),
            
          ],
        ),
      ),
    );
  }
  // Optional: Function to clear all saved asset IDs
// Future<void> clearSavedAssetIds() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove(IMAGE_ASSETS_KEY);
//   await prefs.remove(VIDEO_ASSETS_KEY);
// }

// Optional: Function to check saved assets
// void checkSavedAssets() async {
//   Map<String, List<String>> assets = await getSavedAssetIds();
//   log('Saved Image Asset IDs: ${assets['images']}');
// log('Saved Video Asset IDs: ${assets['videos']}');
// }
// void checkCurrentAssets() async {
//   Map<String, List<String>> assets = await getSavedAssetIds();
//   log('Current Image Assets: ${assets['images']}');
//   log('Current Video Assets: ${assets['videos']}');
// }
}
