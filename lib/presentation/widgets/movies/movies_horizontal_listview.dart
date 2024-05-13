
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class MoviesHorizontalListView extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;


  const MoviesHorizontalListView({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage
  });

  @override
  State<MoviesHorizontalListView> createState() => _MoviesHorizontalListViewState();
}

class _MoviesHorizontalListViewState extends State<MoviesHorizontalListView> {

  final scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if(widget.loadNextPage == null) return;

      if((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Column(
        children: [
          if(widget.title != null || widget.subTitle != null)
            _TitleView(title: widget.title,subTitle: widget.subTitle,),
          
          Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal,
                physics:  const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return FadeInRight(child: _SlideMovie(movie: widget.movies[index]));
                }
              ) 
            ),
        ],
      ),
    );
  }
}

class _SlideMovie extends StatelessWidget {

  final Movie movie;

  const _SlideMovie({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    const double widthPoster = 150;

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: widthPoster,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(movie.posterPath, 
                    fit: BoxFit.cover,
                    width: widthPoster,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress != null){
                        return const Center(child:  CircularProgressIndicator(strokeWidth: 2,));
                      }
                      return GestureDetector(
                        onTap: () => context.push('/movie/${movie.id}'),
                        child:FadeIn(child: child) ,
                      ); 
                    },
                  ),
                ),
              ),

              const SizedBox(height: 5,),

              SizedBox(
                width: widthPoster,
                child: Text(movie.title, 
                          maxLines: 3,
                          style: textStyle.titleSmall,
                      ),
              ),

              //* Rating 
              SizedBox(
                width: widthPoster,
                child: Row(
                  children: [
                    Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
                    const SizedBox(width: 5,),
                    Text(movie.voteAverage.toStringAsFixed(1),style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800) ,),
                    const Spacer(),
                     Icon(Icons.groups_2_outlined, color: Colors.grey.shade800,),
                    const SizedBox(width: 5,),
                    Text(HumanFormats.number(movie.popularity),style: textStyle.bodySmall,),
                  ],
                ),
              )

            ],
          ),
        );
  }
}

class _TitleView extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _TitleView({
    this.title,
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
            Text(title ?? '', style: titleStyle,),

          const Spacer(),

          if(subTitle != '' && subTitle != null)
          FilledButton.tonal(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: (){}, 
                child: Text(subTitle ?? '',)
          ),
            
        ],
      ),
    );
  }
}