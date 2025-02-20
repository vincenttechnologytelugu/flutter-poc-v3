import 'package:get/get.dart';

class LocationController extends GetxController {
  
  final RxString location = ''.obs;
  final RxString city = ''.obs;
  final RxString state = ''.obs;

  void updateLocation({
    String? location,
    String? city,
    String? state,
  }) {
    if (location != null) this.location.value = location;
    if (city != null) this.city.value = city;
    if (state != null) this.state.value = state;
    update();
  }

  String get formattedLocation {
    List<String> parts = [];
    if (location.isNotEmpty) parts.add(location.value);
    if (city.isNotEmpty) parts.add(city.value);
    if (state.isNotEmpty) parts.add(state.value);
    return parts.join(', ');
  }
}
