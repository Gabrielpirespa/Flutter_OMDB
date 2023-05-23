class MovieResponse {
  final String? Title;
  final String? imdbID;
  final String? Poster;

  MovieResponse({this.Title,this.imdbID,this.Poster});

  factory MovieResponse.fromMap(Map<String, dynamic> map) { //Este factory pega os mapas do JSON e transforma em um objeto MovieResponse.
    return MovieResponse(
      Title: map['Title'],
      imdbID: map['imdbID'],
      Poster: map['Poster'],
    );
  }
}
