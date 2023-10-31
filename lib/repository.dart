import 'package:dio/dio.dart';
import 'package:flutter_9/albums.dart';
import 'package:flutter_9/url.dart';

class Repository {
  final UrlApi _api;

  Repository(Dio dio) : _api = UrlApi(dio);

  Future<List<Album>> fetchAlbums() => _api.getAlbums();
}
