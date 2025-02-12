import 'package:cloudinary_sdk/cloudinary_sdk.dart';

final cloudinary = Cloudinary.full(
  apiKey: 'YOUR_API_KEY',
  apiSecret: 'YOUR_API_SECRET',
  cloudName: 'YOUR_CLOUD_NAME',
);

Future<String?> uploadImage(String filePath) async {
  final response = await cloudinary.uploadResource(
    CloudinaryUploadResource(
      filePath: filePath,
      resourceType: CloudinaryResourceType.image,
      folder: "flutter_uploads", // Optional folder
    ),
  );

  return response.secureUrl; // This is the URL you use for downloading
}



