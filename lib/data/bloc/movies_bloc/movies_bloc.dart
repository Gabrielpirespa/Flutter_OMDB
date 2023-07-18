import 'dart:async';
import 'package:flutter_http/data/bloc/movies_bloc/movies_event.dart';
import 'package:flutter_http/data/bloc/movies_bloc/movies_state.dart';
import 'package:flutter_http/data/model/movie_response.dart';
import 'package:flutter_http/data/repositories/movies_repository.dart';


class MoviesBloc {
  final IMoviesRepository repository;

  final StreamController<MoviesEvent> _inputMoviesController = StreamController<MoviesEvent>();

  final StreamController<MoviesState> _outputMoviesController = StreamController<MoviesState>();

  Sink<MoviesEvent> get inputMovies => _inputMoviesController.sink;

  Stream<MoviesState> get outputMovies => _outputMoviesController.stream;

  MoviesBloc({required this.repository}) {
    _outputMoviesController.add(MoviesInitialState());
    _inputMoviesController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(MoviesEvent event) async {
    List<MovieResponse>? movies = [];

    if (event is GetMovies) {
      _outputMoviesController.add(MoviesLoadingState());
      movies = await repository.getMovies(event.search);
    }

    if (movies != null) {
      _outputMoviesController.add(MoviesLoadedState(movies: movies));
    } else {
      _outputMoviesController.add(MoviesNotFoundErrorState());
    }

  }
}