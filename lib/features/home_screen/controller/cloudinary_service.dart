import 'package:ct_festival/config/api_keys.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class CloudinaryService {
  static final String cloudName = CloudinaryDetails.cloudName;
  static final String uploadPreset = CloudinaryDetails.uploadPreset;
  static final String apiUrl = 'https://api.cloudinary.com/v1_1/$cloudName/upload';
  static final AppLogger logger = AppLogger();

/// Uploads an image to Cloudinary and returns the uploaded image URL
  Future<String> uploadImage(PlatformFile file, String customName) async {
    if (file.bytes == null) throw Exception('No file bytes available');

    final url = Uri.parse(apiUrl);
    
    // Convert file bytes to base64
    final base64Image = base64Encode(file.bytes!);
    
    // Generate a timestamp-based name if custom name is empty
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final defaultName = 'image_$timestamp';
    
    // More thorough sanitization of the custom name
    final sanitizedName = (customName.isEmpty ? defaultName : customName)
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '')
        .toLowerCase();
    
    logger.logInfo('Original name: $customName');
    logger.logInfo('Sanitized name: $sanitizedName');
    
    // Create the request body with proper formatting
    final body = jsonEncode({
      'file': 'data:${file.extension == 'png' ? 'image/png' : 'image/jpeg'};base64,$base64Image',
      'upload_preset': uploadPreset,
      'folder': 'ct_festival', // Add a folder to organize uploads
      'filename_override': sanitizedName, // Use filename_override instead of public_id
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        final imageUrl = jsonMap['secure_url'] as String;
        logger.logInfo('Image uploaded successfully: $imageUrl');
        return imageUrl;
      } else {
        final error = 'Failed to upload image: ${response.statusCode} - ${response.body}';
        logger.logError(error);
        throw Exception(error);
      }
    } catch (e) {
      logger.logError('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }
}