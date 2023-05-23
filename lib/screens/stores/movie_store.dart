import 'package:flutter/cupertino.dart';
import 'package:flutter_http/data/model/movie_response.dart';
import 'package:flutter_http/data/repositories/movies_repository.dart';
import 'package:flutter_http/services/exceptions.dart';

class MovieStore {
  //O primeiro passo é gerar uma instâncio do repository.

  final IMoviesRepository repository;

  MovieStore({required this.repository});

  //A Store gerencia o estado da aplicação e deve trabalhar com três tipos de estados

  //O primeiro é o loading e aqui se deve criar uma variável reativa para o loading.

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false); //O value notifier transforma a variável isLoading em reativa com o estado inicial false.

  //O segundo é o state e aqui se deve criar uma variável reativa para o state.

  //O estado desejado para a tela é uma lista de Movie response, então cria-se o value notifier para isso.

  final ValueNotifier<List<MovieResponse>?>? state =
      ValueNotifier<List<MovieResponse>?>([]); //Coloca o estado inicial como uma lista vazia.

  //O terceiro é o erro e aqui se deve criar uma variável reativa para o erro.

  final ValueNotifier<String> error = ValueNotifier<String>(
      ''); //Texto de erro a ser exibido na tela é iniciado como vazio.

  //Para alterar os valores dessas variáveis reativas ocorre só chamando o repository;

  Future getMovies(String search) async {
    isLoading.value = true; //Inicia o loading.
      try {
        final result = await repository.getMovies(search); //Chama a função do repositório que gera a lista de MovieResponse.
        state?.value = result; //Altera o state para a lista recebida do Json.
      } on NotFoundException catch (e) {
        error.value = e
            .message; //Caso caia na exceção criada o error recebe o texto da exceção.
      } catch (e) {
        error.value = e
            .toString(); //Caso caia na exceção mais genérica o error recebe a mensagem dela.
      }
      isLoading.value =
          false; //Após o resultado da chamada a API finaliza o loading.
  }
}
