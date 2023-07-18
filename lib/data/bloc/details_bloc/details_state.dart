import 'package:flutter_http/data/model/description_model.dart';

abstract class DetailsState {
  final DescriptionModel? details;

  DetailsState({required this.details});
}

class DetailsInitialState extends DetailsState {
  DetailsInitialState() : super(details: null);
}

class DetailsLoadingState extends DetailsState {
  DetailsLoadingState() : super(details: null);
}

class DetailsLoadedState extends DetailsState {
  DetailsLoadedState({required DescriptionModel? details}) : super(details: details);
}

// class DetailsErrorState extends DetailsState {
//   final Exception exception;
//
//   DetailsErrorState({required this.exception}) : super(details: null);
// }