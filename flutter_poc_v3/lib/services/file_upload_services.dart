// services/file_upload_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FileUploadService {
  static Future<Map<String, dynamic>> uploadFile({
    required File file,
    required String adpostId,
    required String token,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://13.200.179.78/adposts/upload_file?adpostId=$adpostId'),
      );

      // Add file to request
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      );
      request.files.add(multipartFile);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }
}
