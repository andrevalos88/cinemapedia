

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _HomeView(),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.read(nowlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingrMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }


  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoaingProvier);
    if(initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideShowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upComingMovies = ref.watch(upcomingrMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                children: [
              
                  MoviesSlideShow(movies: slideShowMovies),
                  
                  MoviesHorizontalListView(
                    movies: nowPlayingMovies,
                    title: 'Solo en cines',
                    subTitle: 'Lunes 20',
                    loadNextPage: (){
                      ref.read(nowlayingMoviesProvider.notifier).loadNextPage();
                    },
                  ),
              
                  MoviesHorizontalListView(
                    movies: upComingMovies,
                    title: 'Proximamente',
                    subTitle: 'Este mes',
                    loadNextPage: (){
                      ref.read(upcomingrMoviesProvider.notifier).loadNextPage();
                    },
                  ),
              
                  MoviesHorizontalListView(
                    movies: popularMovies,
                    title: 'Populares',
                    //subTitle: 'Este mes',
                    loadNextPage: (){
                      ref.read(popularMoviesProvider.notifier).loadNextPage();
                    },
                  ),
              
                  MoviesHorizontalListView(
                    movies: topRatedMovies,
                    title: 'Mejor calificadas',
                    subTitle: 'De todos los tiempos',
                    loadNextPage: (){
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                    },
                  ),

                  const SizedBox(height: 15,)
                ], 
              );
            },
            childCount: 1
          ),
        ),
      ],
    );
  }
}