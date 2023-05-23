import 'dart:convert';

import 'package:flutter_http/data/model/movie_response.dart';
import 'package:flutter_http/services/exceptions.dart';
import 'package:flutter_http/services/http_client.dart';

abstract class IMoviesRepository { // Cria uma classe abstrata para todos que usarem esse repository terem que implementar suas condições.
  Future<List<MovieResponse>?> getMovies(String search);
}

class MoviesRepository implements IMoviesRepository {
  final IHttpClient client;

  MoviesRepository({required this.client});

  @override
  Future<List<MovieResponse>?> getMovies(String search) async {
    String url = "https://www.omdbapi.com/?apikey=503f6071&s=${search.toLowerCase().replaceAll(RegExp(' +'), '_')}"; //Insere a palavra pesquisada na url

    print(url);

    final response = await client.get(url: url);

    if(response.statusCode == 200){

      final List<MovieResponse> moviesList; //Cria uma lista para ser populada posteriormente.

      final body = jsonDecode(response.body); //Recebe a resposta do Json Decodificada.

      if (body["Response"] == "False"){
        return null;
      }

      Iterable list = body["Search"]; //Faz com que o objeto recebido possa ser iterado. (importante para gerar os objetos individuais dos filmes a partir da lista).

      final movies = list.map((movie) => MovieResponse.fromMap(movie)).toList(); //Essa linha transforma cada item do mapa em um objeto MovieResponse (um filme);

      moviesList = movies; //Essa linha popula a lista inicial com os filmes transformados vindos no JSON;

      return moviesList; //Retorna a lista de filmes populada.

    } else if (response.statusCode == 404) {
      throw NotFoundException(message: "A url não é válida");
    } else {
      throw Exception("Não foi possível carregar a página");
    }
  }
}