import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/movie.dart';
import '../../services/firestore_service.dart';
import '../../services/yts_api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirestoreService _firestoreService;
  final YtsApiService _apiService;

  StreamSubscription<List<int>>? _favoritesSubscription;
  StreamSubscription<List<int>>? _historySubscription;

  ProfileBloc({
    FirestoreService? firestoreService,
    YtsApiService? apiService,
  })  : _firestoreService =
      firestoreService ?? FirestoreService(),
        _apiService = apiService ?? YtsApiService(),
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<FavoritesChanged>(_onFavoritesChanged);
    on<HistoryChanged>(_onHistoryChanged);
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    try {
      await _favoritesSubscription?.cancel();
      await _historySubscription?.cancel();

      final profile =
      await _firestoreService.getUserProfile(event.uid);

      emit(
        ProfileLoaded(
          profile: profile,
          watchlist: const [],
          history: const [],
          watchlistLoading: true,
          historyLoading: true,
        ),
      );

      _favoritesSubscription =
          _firestoreService.watchFavoriteIds(event.uid).listen(
                (ids) {
              add(FavoritesChanged(ids));
            },
          );

      _historySubscription =
          _firestoreService.watchHistoryIds(event.uid).listen(
                (ids) {
              add(HistoryChanged(ids));
            },
          );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onFavoritesChanged(
      FavoritesChanged event,
      Emitter<ProfileState> emit,
      ) async {
    final currentState = state;

    if (currentState is! ProfileLoaded) return;

    emit(
      currentState.copyWith(
        watchlistLoading: true,
      ),
    );

    try {
      final movies = await _getMovies(event.movieIds);

      if (state is ProfileLoaded) {
        emit(
          (state as ProfileLoaded).copyWith(
            watchlist: movies,
            watchlistLoading: false,
          ),
        );
      }
    } catch (_) {
      if (state is ProfileLoaded) {
        emit(
          (state as ProfileLoaded).copyWith(
            watchlist: const [],
            watchlistLoading: false,
          ),
        );
      }
    }
  }

  Future<void> _onHistoryChanged(
      HistoryChanged event,
      Emitter<ProfileState> emit,
      ) async {
    final currentState = state;

    if (currentState is! ProfileLoaded) return;

    emit(
      currentState.copyWith(
        historyLoading: true,
      ),
    );

    try {
      final movies = await _getMovies(event.movieIds);

      if (state is ProfileLoaded) {
        emit(
          (state as ProfileLoaded).copyWith(
            history: movies,
            historyLoading: false,
          ),
        );
      }
    } catch (_) {
      if (state is ProfileLoaded) {
        emit(
          (state as ProfileLoaded).copyWith(
            history: const [],
            historyLoading: false,
          ),
        );
      }
    }
  }

  Future<List<Movie>> _getMovies(List<int> ids) async {
    if (ids.isEmpty) return [];

    final results = await Future.wait(
      ids.map(
            (id) => _apiService.getMovieById(id),
      ),
    );

    return results.whereType<Movie>().toList();
  }

  @override
  Future<void> close() async {
    await _favoritesSubscription?.cancel();
    await _historySubscription?.cancel();
    return super.close();
  }
}