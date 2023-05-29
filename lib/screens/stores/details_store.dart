import 'package:flutter/cupertino.dart';
import 'package:flutter_http/data/model/description_model.dart';
import 'package:flutter_http/data/repositories/details_repository.dart';
import 'package:flutter_http/services/exceptions.dart';

//A Store gerencia o estado da aplicação e deve trabalhar com três principais tipos de estados.

class DetailsStore {
  //O primeiro passo é instanciar o repository.

  final IDetailsRepository repository;

  DetailsStore({required this.repository});

  //O primeiro estado é o de loading e aqui se deve criar uma variável reativa para o loading.

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  //O segundo é o state e aqui se deve criar uma variável reativa para o state.

  //O estado desejado para a tela é uma Description Model, então cria-se o value notifier para isso.

  final ValueNotifier<DescriptionModel?> state = ValueNotifier(null);

  //O terceiro é o erro e aqui se deve criar uma variável reativa para o erro.

  final ValueNotifier<String> error = ValueNotifier<String>(
      ''); //Texto de erro a ser exibido na tela é iniciado como vazio.

  //Para alterar os valores dessas variáveis reativas ocorre só chamando o repository;

  Future getDetails(String? imdbId) async {
    isLoading.value = true;
    try {
      final result = await repository.getDetails(imdbId); //Chama a função do repositório que gera a lista de MovieResponse.
      state.value = result; //Altera o state para a lista recebida do Json.
    } on NotFoundException catch (e) {
      error.value = e.message; //Caso caia na exceção criada o error recebe o texto da exceção.
    } catch (e) {
      error.value = e.toString(); //Caso caia na exceção mais genérica o error recebe a mensagem dela.
    }
    isLoading.value = false; //Após o resultado da chamada a API finaliza o loading.
  }
}
