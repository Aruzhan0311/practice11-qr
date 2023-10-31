import 'package:dio/dio.dart';
import 'package:flutter_9/albums.dart';
import 'package:retrofit/http.dart';

part 'url.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class UrlApi {
  factory UrlApi(Dio dio, {String baseUrl}) = _UrlApi;

  @GET("/albums")
  Future<List<Album>> getAlbums();
}
