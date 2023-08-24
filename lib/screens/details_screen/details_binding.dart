import 'package:flutter_http/data/bloc/details_bloc/details_bloc.dart';
import 'package:flutter_http/data/repositories/details_repository.dart';
import 'package:flutter_http/services/http_client.dart';
import 'package:get/get.dart';

setUpDetails() {
  Get.put<DetailsBloc>(DetailsBloc(
    repository: DetailsRepository(
      client: HttpClient(),
    ),
  ));
}