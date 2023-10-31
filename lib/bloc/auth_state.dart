import 'package:flutter_9/albums.dart';

abstract class AuthState {}

class InitialState extends AuthState {}

class LoadingState extends AuthState {}

class LoadedAlbumsState extends AuthState {
  final List<Album> albums;

  LoadedAlbumsState(this.albums);
}

class ErrorState extends AuthState {
  final String message;

  ErrorState(this.message);
}
