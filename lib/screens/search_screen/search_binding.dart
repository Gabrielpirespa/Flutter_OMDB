import 'package:flutter_http/data/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_http/data/repositories/movies_repository.dart';
import 'package:flutter_http/services/http_client.dart';
import 'package:get/get.dart';

setUpSearch() {
  Get.put<MoviesBloc>(MoviesBloc(
    repository: MoviesRepository(
      client: HttpClient(),
    ),
  ));
}
