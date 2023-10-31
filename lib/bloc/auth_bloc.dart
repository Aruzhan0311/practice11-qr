import 'package:flutter_9/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final Repository repository;

  AuthBloc({required this.repository}) : super(InitialState());

  void loadAlbums() async {
    emit(LoadingState());

    try {
      final albums = await repository.fetchAlbums();
      emit(LoadedAlbumsState(albums));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
