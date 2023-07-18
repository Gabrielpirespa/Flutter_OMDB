import 'package:flutter_http/data/model/movie_response.dart';

abstract class MoviesState {
  final List<MovieResponse>? movies;

  MoviesState({required this.movies});
}

class MoviesInitialState extends MoviesState {
  MoviesInitialState() : super(movies: []);
}

class MoviesLoadingState extends MoviesState {
  MoviesLoadingState() : super(movies: []);
}

class MoviesLoadedState extends MoviesState {
  MoviesLoadedState({required List<MovieResponse>? movies}) : super(movies: movies);
}

class MoviesNotFoundErrorState extends MoviesState {
  MoviesNotFoundErrorState() : super(movies: null);
}

// class MoviesApiErrorState extends MoviesState {
//   final Exception exception;
//
//   MoviesApiErrorState({required this.exception}) : super(movies: []);
// }