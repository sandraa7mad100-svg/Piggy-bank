import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction over connectivity so repositories can decide when to fall
/// back to cached/local data (Offline Mode) instead of hitting Firebase.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map((results) => !results.contains(ConnectivityResult.none));
}
