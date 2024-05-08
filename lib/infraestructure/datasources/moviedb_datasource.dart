

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/movieDb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDBDataSource extends MovieDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      }
    )
  );
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('movie/now_playing');
    final movieDBresponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBresponse.results
    .where((element) => element.posterPath != 'no-poster')
    .map(
        (e) => MovieMapper.movieDBToEntity(e)
      ).toList();
    return movies;
  }

  
}