import 'package:geolocator/geolocator.dart';

class PositionService {
  PositionService();

  Future<bool> checkServiceLocation() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
}
