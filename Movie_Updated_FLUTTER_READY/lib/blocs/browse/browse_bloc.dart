import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie.dart';
import '../../services/yts_api_service.dart';
import 'browse_event.dart';
import 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final YtsApiService _apiService;

  List<Movie> _allMovies = [];
  List<String> _genres = [];

  BrowseBloc({
    YtsApiService? apiService,
  })  : _apiService = apiService ?? YtsApiService(),
        super(BrowseInitial()) {
    on<LoadBrowseMovies>(_onLoadMovies);
    on<SelectBrowseGenre>(_onSelectGenre);
  }

  Future<void> _onLoadMovies(
      LoadBrowseMovies event,
      Emitter<BrowseState> emit,
      ) async {
    emit(BrowseLoading());

    try {
      final movies = await _apiService.getMovies();

      if (movies.isEmpty) {
        emit(BrowseEmpty());
        return;
      }

      _allMovies = movies;

      final genreSet = <String>{};

      for (final movie in movies) {
        genreSet.addAll(movie.genres);
      }

      _genres = genreSet.toList()..sort();

      if (_genres.isEmpty) {
        emit(
          BrowseSuccess(
            movies: movies,
            genres: const [],
            selectedGenre: '',
          ),
        );
        return;
      }

      final firstGenre = _genres.first;

      final filteredMovies = movies
          .where((movie) => movie.genres.contains(firstGenre))
          .toList();

      emit(
        BrowseSuccess(
          movies: filteredMovies,
          genres: _genres,
          selectedGenre: firstGenre,
        ),
      );
    } catch (e) {
      emit(BrowseError(e.toString()));
    }
  }

  void _onSelectGenre(
      SelectBrowseGenre event,
      Emitter<BrowseState> emit,
      ) {
    if (_allMovies.isEmpty) return;

    final filteredMovies = _allMovies
        .where((movie) => movie.genres.contains(event.genre))
        .toList();

    emit(
      BrowseSuccess(
        movies: filteredMovies,
        genres: _genres,
        selectedGenre: event.genre,
      ),
    );
  }
}