import 'package:flutter/material.dart';
import 'package:flutter_http/components/error_pattern.dart';
import 'package:flutter_http/components/loading.dart';
import 'package:flutter_http/data/bloc/details_bloc/details_bloc.dart';
import 'package:flutter_http/data/bloc/details_bloc/details_event.dart';
import 'package:flutter_http/data/bloc/details_bloc/details_state.dart';
import 'package:flutter_http/data/repositories/details_repository.dart';
import 'package:flutter_http/services/http_client.dart';

class DetailsScreen extends StatefulWidget {
  final String? id;

  const DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final DetailsBloc _detailsBloc;

  @override
  void initState() {
    super.initState();
    _detailsBloc = DetailsBloc(
      repository: DetailsRepository(
        client: HttpClient(),
      ),
    );
    _detailsBloc.inputDetails.add(
      GetDetails(
        imdbId: widget.id,
      ),
    ); // Chama a função do BLoC que pega os dados de detalhes da API pelo DetailsRepository.
  }

  @override
  void dispose() {
    _detailsBloc.inputDetails.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(206, 131, 124, 1.0),
              Color.fromRGBO(225, 111, 111, 1.0),
              Color.fromRGBO(246, 140, 82, 1.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
                right: 30,
                left: 30,
              ),
              child: StreamBuilder<DetailsState>(
                stream: _detailsBloc.outputDetails,
                builder: (context, state) {
                  if (state.data is DetailsLoadingState) {
                    return SizedBox(
                      height: mediaQuery.height,
                      width: mediaQuery.width,
                      child: const Loading(),
                    );
                  } else if (state.data is DetailsLoadedState) {
                    final details = state.data?.details;

                    return Column(children: [
                      Text(
                        details?.Title ?? '',
                        style:
                            const TextStyle(fontSize: 28, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 16, right: 8, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              details?.Genre ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "IMDB: ${details?.imdbRating}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          details?.Poster ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          details?.Type == "movie"
                              ? "${details?.Year} - ${details?.Runtime} - ${details?.Language}"
                              : "${details?.Year} - ${details?.Type}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          details?.Plot ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ]);
                  } else {
                    return Center(
                      widthFactor: mediaQuery.width * 0.008,
                      heightFactor: mediaQuery.height * 0.008,
                      child: const ErrorPattern(
                        errorText: "Unknown error",
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
