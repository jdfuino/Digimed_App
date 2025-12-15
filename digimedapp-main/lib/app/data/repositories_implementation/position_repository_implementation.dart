import 'package:digimed/app/data/providers/local/position_service.dart';
import 'package:digimed/app/domain/repositories/position_repository.dart';
import 'package:geolocator_platform_interface/src/enums/location_permission.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class PositionRepositoryImplementation implements PositionRepository{

  PositionService positionService;

  PositionRepositoryImplementation({required this.positionService});

  @override
  Future<LocationPermission> checkPermission() {
    return positionService.checkPermission();
  }

  @override
  Future<bool> checkServiceLocation() {
    return positionService.checkServiceLocation();
  }

  @override
  Future<Position> getCurrentLocation() {
    return positionService.getCurrentLocation();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return positionService.requestPermission();
  }

}