import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m/core/theme/app_colors.dart';
import 'package:m/screens/movie_details/bloc/movie_details_state.dart';
import 'package:m/screens/movie_details/data/repo/movie_details_repo.dart';
import 'package:m/screens/movie_details/view/widgets/movie_details_content.dart';
import 'package:m/screens/movie_details/view/widgets/movie_details_error.dart';
import 'package:m/screens/movie_details/view/widgets/movie_details_loading.dart';
import '../bloc/movie_details_bloc.dart';
import '../bloc/movie_details_event.dart';


class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailsBloc(
        movieDetailsRepo: MovieDetailsRepo(),
      )..add(FetchMovieDetails(movieId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: MovieDetailsScreenBody(
          movieId: movieId,
        ),
      ),
    );
  }


}


class MovieDetailsScreenBody extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreenBody({super.key, required this.movieId});

  @override
  State<MovieDetailsScreenBody> createState() => _MovieDetailsScreenBodyState();
}

class _MovieDetailsScreenBodyState extends State<MovieDetailsScreenBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsInitial ||
            state is MovieDetailsLoading) {
          return const MovieDetailsLoadingView();
        }

        if (state is MovieDetailsError) {
          return MovieDetailsErrorView(
            message: state.message,
            onRetry: _fetchMovieDetails,
          );
        }

        if (state is MovieDetailsLoaded) {
          return MovieDetailsContent(
            movie: state.movie,
            suggestions: state.suggestions,
            onRefresh: _refreshMovieDetails,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _fetchMovieDetails() {
    context
        .read<MovieDetailsBloc>()
        .add(FetchMovieDetails(widget.movieId));
  }

  Future<void> _refreshMovieDetails() async {
    context
        .read<MovieDetailsBloc>()
        .add(RefreshMovieDetails(widget.movieId));
  }

}
