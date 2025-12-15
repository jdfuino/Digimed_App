import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digimed/app/data/providers/remote/internet_checker.dart';
import 'package:digimed/app/domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImplementation implements ConnectivityRepository{
  final Connectivity _connectivity;
  final InternetChecker _internetChecker;

  ConnectivityRepositoryImplementation(
      this._connectivity,
      this._internetChecker);

  @override
  Future<bool> get hasInternet async {
    final connectivityResult = await (_connectivity.checkConnectivity());

    if(connectivityResult == ConnectivityResult.none){
      return false;
    }

    return _internetChecker.hasInternet();

  }


}