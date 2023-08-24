import 'package:bloc/bloc.dart';
import 'package:flutter_http/data/bloc/details_bloc/details_event.dart';
import 'package:flutter_http/data/bloc/details_bloc/details_state.dart';
import 'package:flutter_http/data/model/description_model.dart';
import 'package:flutter_http/data/repositories/details_repository.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final IDetailsRepository repository;

  DetailsBloc({required this.repository}) : super(DetailsInitialState()) {
    on(_mapEventToState);
  }

  void _mapEventToState(DetailsEvent event, Emitter emit) async {
    DescriptionModel? details;

    emit(DetailsLoadingState());

    if (event is GetDetails) {
      details = await repository.getDetails(event.imdbId);
    }

    emit(DetailsLoadedState(details: details));
  }
}