
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideShowProvider = Provider<List<Movie>>((ref){
  final nowPlayingmovies = ref.watch(nowlayingMoviesProvider);

  if(nowPlayingmovies.isEmpty) return [];

  return nowPlayingmovies.sublist(0,6);
});