import 'package:flutter/material.dart';
import 'package:m/screens/movie_details/data/models/movie_data_model.dart';
import 'package:m/screens/movie_details/view/widgets/build_movie_cast.dart';
import 'package:m/screens/movie_details/view/widgets/build_movie_genres.dart';
import 'package:m/screens/movie_details/view/widgets/build_movie_header.dart';
import 'package:m/screens/movie_details/view/widgets/build_movie_summary.dart';
import 'package:m/screens/movie_details/view/widgets/build_screenshots.dart';
import 'package:m/screens/movie_details/view/widgets/build_similar_movies.dart';
import 'package:m/screens/movie_details/view/widgets/build_statistics_row.dart';
import 'package:m/screens/movie_details/view/widgets/build_watch_button.dart';


class MovieDetailsContent extends StatelessWidget {
  final MovieDetailsModel movie;
  final List<Movie> suggestions;
  final Future<void> Function()? onRefresh;

  const MovieDetailsContent({
    super.key,
    required this.movie,
    required this.suggestions,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    // final body = CustomScrollView(
    //   slivers: [
    //     SliverAppBar(
    //       expandedHeight: height * .5,
    //       pinned: true,
    //       backgroundColor: Colors.transparent,
    //       flexibleSpace: FlexibleSpaceBar(
    //         background: BuildMovieHeader(movie: movie),
    //
    //       ),
    //     ),
    //     SliverList(
    //       delegate: SliverChildListDelegate([
    //         Padding(
    //             padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
    //             child: Column(
    //               children: [
    //                 SizedBox(height: 10,),
    //                 BuildWatchButton(movie: movie),
    //                 BuildStatisticsRow(movie: movie),
    //                 BuildScreenshots(movie: movie),
    //                 BuildSimilarMovies(movie: movie, suggestions: suggestions),
    //                 BuildMovieSummary(movie: movie),
    //                 BuildMovieCast(movie: movie),
    //                 BuildMovieGenres(movie: movie),
    //
    //               ],
    //             ),
    //         ),
    //
    //
    //
    //         // MovieInfoRow(movie: movie),
    //         // MovieOverviewSection(overview: movie.overview ?? ""),
    //         // MovieSuggestionsSection(
    //         //   suggestions: suggestions,
    //         //   onMovieTap: onSuggestionTap,
    //         // ),
    //         const SizedBox(height: 20),
    //       ]),
    //     ),
    //   ],
    // );


    final body = SingleChildScrollView(
      child: Column(
        children: [
          BuildMovieHeader(movie: movie),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildWatchButton(movie: movie),
                SizedBox(height: 16,),
                BuildStatisticsRow(movie: movie),
                SizedBox(height: 16,),
                BuildScreenshots(movie: movie),
                SizedBox(height: 16,),
                BuildSimilarMovies(movie: movie, suggestions: suggestions),
                SizedBox(height: 16,),
                BuildMovieSummary(movie: movie),
                SizedBox(height: 16,),
                BuildMovieCast(movie: movie),
                SizedBox(height: 16,),
                BuildMovieGenres(movie: movie),


                SizedBox(height: 20,),

              ],
            ),
          ),




        ],
      ),
    );

    if (onRefresh == null) return body;
    return RefreshIndicator(onRefresh: onRefresh!, child: body);
  }
}
