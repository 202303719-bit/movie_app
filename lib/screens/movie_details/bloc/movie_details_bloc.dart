import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/movie_details_repo.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieDetailsRepo movieDetailsRepo;

  MovieDetailsBloc({required this.movieDetailsRepo})
      : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>(_onFetchMovieDetails);
    on<RefreshMovieDetails>(_onFetchMovieDetails); // same handler, no spinner reset needed if you want silent refresh
  }

  Future<void> _onFetchMovieDetails(
    MovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    final movieId = switch (event) {
      FetchMovieDetails(:final movieId) => movieId,
      RefreshMovieDetails(:final movieId) => movieId,
      _ => throw StateError('Unhandled event type'),
    };

    emit(MovieDetailsLoading());
    try {
      // Start both API calls first, then await — this runs them in
      // parallel so total wait time = the slower of the two, not the sum.
      final detailsFuture = movieDetailsRepo.getMovieDetails(movieId);
      final suggestionsFuture = movieDetailsRepo.getMovieSuggestions(movieId);

      final movie = await detailsFuture;
      final suggestions = await suggestionsFuture;
      final suggestionsList = suggestions.data.movies;

      emit(MovieDetailsLoaded(movie: movie, suggestions: suggestionsList));
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }
}
