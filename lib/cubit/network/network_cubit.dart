import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity connectivity = Connectivity();

  NetworkCubit() : super(NetworkInitial()) {
    monitorNetwork();
  }

  void monitorNetwork() {
    connectivity.onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        emit(NetworkDisconnected());
      } else {
        emit(NetworkConnected());
      }
    });
  }
}
