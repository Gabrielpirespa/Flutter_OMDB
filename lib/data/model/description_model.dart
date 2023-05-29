class DescriptionModel {
  final String? Title;
  final String? Year;
  final String? Runtime;
  final String? Genre;
  final String? Plot;
  final String? Language;
  final String? Poster;
  final String? Metascore;
  final String? imdbRating;
  final String? Type;

  DescriptionModel({
    this.Title,
    this.Year,
    this.Runtime,
    this.Genre,
    this.Plot,
    this.Language,
    this.Poster,
    this.Metascore,
    this.imdbRating,
    this.Type,
  });

  factory DescriptionModel.fromJson(Map<String, dynamic> map) { //Este factory pega os mapas do JSON e transforma em um objeto DescriptionModel.
    return DescriptionModel(
      Title: map['Title'],
      Year: map['Year'],
      Runtime: map['Runtime'],
      Genre: map['Genre'],
      Plot: map['Plot'],
      Language: map['Language'],
      Poster: map['Poster'],
      Metascore: map['Metascore'],
      imdbRating: map['imdbRating'],
      Type: map['Type'],
    );
  }
}
