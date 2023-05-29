import 'dart:convert';

import 'package:flutter_http/data/model/description_model.dart';
import 'package:flutter_http/services/exceptions.dart';
import 'package:flutter_http/services/http_client.dart';

abstract class IDetailsRepository { // Cria uma classe abstrata para todos que usarem esse repository terem que implementar suas condições.
  Future<DescriptionModel?> getDetails(String? imdbId);
}

class DetailsRepository implements IDetailsRepository {
  final IHttpClient client;

  DetailsRepository({required this.client});

  @override
  Future<DescriptionModel?> getDetails(String? imdbId) async {
    String url = "https://www.omdbapi.com/?apikey=503f6071&i=$imdbId&plot=full"; //Insere a palavra pesquisada na url

    print(url);

    final response = await client.get(url: url);

    if(response.statusCode == 200){

      final DescriptionModel movieDetail = DescriptionModel.fromJson(jsonDecode(response.body));

      print("esse é o body da requisição: $movieDetail");

      return movieDetail;

    } else if (response.statusCode == 404) {
      throw NotFoundException(message: "A url não é válida");
    } else {
      throw Exception("Não foi possível carregar a página");
    }
  }
}