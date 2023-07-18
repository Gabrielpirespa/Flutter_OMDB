abstract class MoviesEvent {}

class GetMovies extends MoviesEvent {
  final String search;

  GetMovies({required this.search});
}