// media_upload_controller.dart
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MediaUploadController extends GetxController {
  RxList<XFile> selectedImages = <XFile>[].obs;
  Rx<XFile?> selectedVideo = Rx<XFile?>(null);
  RxBool isUploading = false.obs;
  
  void clearMedia() {
    selectedImages.clear();
    selectedVideo.value = null;
  }
}
