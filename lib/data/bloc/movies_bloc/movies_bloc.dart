import 'package:bloc/bloc.dart';
import 'package:flutter_http/data/bloc/movies_bloc/movies_event.dart';
import 'package:flutter_http/data/bloc/movies_bloc/movies_state.dart';
import 'package:flutter_http/data/model/movie_response.dart';
import 'package:flutter_http/data/repositories/movies_repository.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final IMoviesRepository repository;

  MoviesBloc({required this.repository}): super(MoviesInitialState()) {
    on(_mapEventToState);
  }

  void _mapEventToState(MoviesEvent event, Emitter emit) async {
    List<MovieResponse>? movies = [];

    if (event is GetMovies) {
      emit(MoviesLoadingState());
      movies = await repository.getMovies(event.search);
    }

    if (movies != null) {
      emit(MoviesLoadedState(movies: movies));
    } else {
      emit(MoviesNotFoundErrorState());
    }
  }
}