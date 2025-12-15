
import 'package:geolocator/geolocator.dart';

abstract class PositionRepository{
  Future<bool> checkServiceLocation();
  Future<LocationPermission> checkPermission();
  Future<Position> getCurrentLocation();
  Future<LocationPermission> requestPermission();
}