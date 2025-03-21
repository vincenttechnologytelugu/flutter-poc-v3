import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/asset_model.dart';
import 'package:flutter_poc_v3/models/product_model.dart' show ProductModel;
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/my_adds.dart';

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
  List<AssetModel> imageAssets = [];
  AssetModel? videoAsset;
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
        AssetModel asset = AssetModel.fromJson(jsonResponse);
        setState(() {
          if (isVideo) {
            videoAsset = asset;
          } else {
            imageAssets.add(asset);
          }
        });
        // Debug print to verify the ID
        log('Uploaded asset ID: ${asset.id}');

        String fileExtension = file.path.split('.').last.toLowerCase();
        bool isImage = ['jpg', 'jpeg', 'png'].contains(fileExtension);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful - ID: ${asset.id}')),
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

// Add this method to your state class
  Future<bool> deleteAssetFromServer(String assetId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final adpostId = prefs.getString('adpostId');

      log('Deleting asset - ID: $assetId, AdpostId: $adpostId'); // Debug log

      final response = await http.post(
        Uri.parse('http://13.200.179.78/adposts/delete_asset'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'adpostId': adpostId,
          'assetId': assetId,
        }),
      );

      log('Delete response: ${response.body}'); // Debug log
      return response.statusCode == 200;
    } catch (e) {
      log('Delete error: $e');
      return false;
    }
  }

// Update the image preview widget to show the ID clearly
// Modify your image preview widget
  Widget _buildImagePreview() {
    return SizedBox(
      height: 180,
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
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
                if (index < imageAssets.length)
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     color: Colors.black.withOpacity(0.7),
                  //     padding: EdgeInsets.all(4),
                  //     child: Text(
                  //       'ID: ${imageAssets[index].id}',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 10,
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      padding: EdgeInsets.all(4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Asset ID:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            imageAssets[index].id,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                // Positioned(
                //   right: 0,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color:
                //           const Color.fromARGB(255, 17, 9, 9).withOpacity(0.5),
                //       shape: BoxShape.circle,
                //     ),
                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.delete_forever_rounded,
                //         color: Color.fromARGB(255, 249, 247, 247),
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           selectedImages.removeAt(index);
                //           if (index < imageAssets.length) {
                //             imageAssets.removeAt(index);
                //           }
                //         });
                //       },
                //     ),
                //   ),
                // ),

                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child:
                        //  IconButton(
                        //   icon: const Icon(
                        //     Icons.delete_forever_rounded,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () async {
                        //     if (index < imageAssets.length) {
                        //       // Show loading indicator
                        //       showDialog(
                        //         context: context,
                        //         barrierDismissible: false,
                        //         builder: (BuildContext context) {
                        //           return Center(child: CircularProgressIndicator());
                        //         },
                        //       );

                        //       // Delete from server
                        //       final success = await deleteAssetFromServer(
                        //           imageAssets[index].id);

                        //       // Remove loading indicator
                        //       Navigator.pop(context);

                        //       if (success) {
                        //         setState(() {
                        //           selectedImages.removeAt(index);
                        //           imageAssets.removeAt(index);
                        //         });

                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           SnackBar(
                        //               content: Text('Image deleted successfully')),
                        //         );

                        //         // Allow picking new image
                        //         await pickImage();
                        //       } else {

                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           SnackBar(content: Text('Failed to delete image')),
                        //         );
                        //       }
                        //     }
                        //   },
                        // ),

                        IconButton(
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          if (index < imageAssets.length) {
                            // Has assetId - delete from server
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            );

                            final success = await deleteAssetFromServer(
                                imageAssets[index].id);
                            Navigator.pop(context);

                            if (success) {
                              setState(() {
                                selectedImages.removeAt(index);
                                imageAssets.removeAt(index);
                              });
                              // Pick new image after successful deletion
                              await pickImage();
                            }
                          } else {
                            // No assetId - just remove from UI and pick new image
                            setState(() {
                              selectedImages.removeAt(index);
                            });
                            // Pick new image
                            await pickImage();
                          }
                        } catch (e) {
                          log('Error in delete operation: $e');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// Update pickImage function
  Future<void> pickImage() async {
    final int maxImages = packageRules?['image_attachments'] ?? 2;

    if (selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum image limit ($maxImages) reached')),
      );
      return;
    }

    // Show dialog first
    bool proceed = await _showFileTypeDialog(false);
    if (!proceed) return;

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
// Show dialog first
    bool proceed = await _showFileTypeDialog(true);
    if (!proceed) return;
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

  // Add this function to show the file type dialog
  Future<bool> _showFileTypeDialog(bool isVideo) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(isVideo ? 'Select Video' : 'Select Image'),
              content: Text(
                isVideo
                    ? 'Please select MP4 video files only'
                    : 'Please select JPEG or PNG image files only',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true when OK is pressed
                  },
                  child: Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false when Cancel is pressed
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  // Modify your video preview widget
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
        color: const Color.fromRGBO(235, 217, 217, 1),
        child: Center(
          child: Icon(
            Icons.video_library_rounded,
            color: Color.fromARGB(255, 244, 6, 38),
            size: 60,
          ),
        ),
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
        if (videoAsset != null)

          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     color: Colors.black.withOpacity(0.7),
          //     padding: EdgeInsets.all(4),
          //     child: Text(
          //       'Video ID: ${videoAsset!.id}',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 12,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),

          Positioned(
            top: 150,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.7),
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Video Asset ID:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    videoAsset!.id,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        // Positioned(
        //   left: 0,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.black.withOpacity(0.5),
        //       shape: BoxShape.circle,
        //     ),
        //     child: IconButton(
        //       icon: Icon(Icons.delete_forever_rounded, color: Colors.white),
        //       onPressed: () async {
        //         await _disposeVideoControllers();
        //         setState(() {
        //           selectedVideo = null;
        //           videoAsset = null;
        //         });
        //       },
        //     ),
        //   ),
        // ),

        Positioned(
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child:
                // IconButton(
                //   icon: Icon(Icons.delete_forever_rounded, color: Colors.white),
                //   onPressed: () async {
                //     if (videoAsset != null) {
                //       // Show loading indicator
                //       showDialog(
                //         context: context,
                //         barrierDismissible: false,
                //         builder: (BuildContext context) {
                //           return Center(child: CircularProgressIndicator());
                //         },
                //       );

                //       // Delete from server
                //       final success = await deleteAssetFromServer(videoAsset!.id);

                //       // Remove loading indicator
                //       Navigator.pop(context);

                //       if (success) {
                //         // Dispose video controllers
                //         await _disposeVideoControllers();
                //         setState(() {
                //           selectedVideo = null;
                //           videoAsset = null;
                //         });

                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('Video deleted successfully')),
                //         );

                //         // Allow picking new video
                //         await pickVideo();
                //       } else {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('Failed to delete video')),
                //         );
                //       }
                //     }
                //   },
                // ),

                IconButton(
              icon: Icon(Icons.delete_forever_rounded, color: Colors.white),
              onPressed: () async {
                try {
                  if (videoAsset != null) {
                    // Has assetId - delete from server
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(child: CircularProgressIndicator());
                      },
                    );

                    final success = await deleteAssetFromServer(videoAsset!.id);
                    Navigator.pop(context);

                    if (success) {
                      await _disposeVideoControllers();
                      setState(() {
                        selectedVideo = null;
                        videoAsset = null;
                      });
                      // Pick new video after successful deletion
                      await pickVideo();
                    }
                  } else {
                    // No assetId - just remove from UI and pick new video
                    await _disposeVideoControllers();
                    setState(() {
                      selectedVideo = null;
                      videoAsset = null;
                    });
                    // Pick new video
                    await pickVideo();
                  }
                } catch (e) {
                  log('Error in delete operation: $e');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    super.dispose();
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

            // For video button
            if (maxVideos > 0) const SizedBox(height: 20),

            // if (selectedImages.isNotEmpty)
            //   SizedBox(
            //     height: 100,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: selectedImages.length,
            //       itemBuilder: (context, index) {
            //         return Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Stack(
            //             children: [
            //               Container(
            //                 decoration: BoxDecoration(
            //                   border: Border.all(color: Colors.black),
            //                 ),
            //                 child: Image.file(
            //                   selectedImages[index],
            //                   height: 100,
            //                   width: 100,
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //               Positioned(
            //                 right: 20,
            //                 top: 40,
            //                 left: 50,
            //                 bottom: 100,
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     color: Colors.black.withOpacity(0.5),
            //                     shape: BoxShape.circle,
            //                   ),
            //                   child: IconButton(
            //                     icon: const Icon(Icons.delete_forever_rounded,
            //                         color: Color.fromARGB(255, 11, 5, 5)),
            //                     onPressed: () {
            //                       setState(() {
            //                         selectedImages.removeAt(index);
            //                       });
            //                     },
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            _buildImagePreview(),

            _buildVideoPreview(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
  padding: EdgeInsets.all(16),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 300),
    child: ElevatedButton(
      onPressed: () {
        // Add a small loading animation before navigation
        showDialog(
          context: context,
          barrierDismissible: false,
          
          builder: (BuildContext context) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(30),
                width: 250,
                height: 250,

                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 114, 104, 104),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),

                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Submitting...',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,

                      ),
                    
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // Delay navigation slightly to show the animation
        Future.delayed(Duration(milliseconds: 10000), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyAdds()),
            (route) => false,
          );
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),

    );
    
  }
}
