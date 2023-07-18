import 'dart:async';
import 'package:flutter_http/data/bloc/details_bloc/details_event.dart';
import 'package:flutter_http/data/bloc/details_bloc/details_state.dart';
import 'package:flutter_http/data/model/description_model.dart';
import 'package:flutter_http/data/repositories/details_repository.dart';


class DetailsBloc {
  final IDetailsRepository repository;

  final StreamController<DetailsEvent> _inputDetailsController = StreamController<DetailsEvent>();

  final StreamController<DetailsState> _outputDetailsController = StreamController<DetailsState>();

  Sink<DetailsEvent> get inputDetails => _inputDetailsController.sink;

  Stream<DetailsState> get outputDetails => _outputDetailsController.stream;

  DetailsBloc({required this.repository}) {
    _inputDetailsController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DetailsEvent event) async {
    DescriptionModel? details;

    _outputDetailsController.add(DetailsLoadingState());

    if (event is GetDetails) {
      details = await repository.getDetails(event.imdbId);
    }

    _outputDetailsController.add(DetailsLoadedState(details: details));
  }
}