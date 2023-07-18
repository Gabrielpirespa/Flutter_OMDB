abstract class DetailsEvent {}

class GetDetails extends DetailsEvent {
  final String? imdbId;

  GetDetails({required this.imdbId});
}