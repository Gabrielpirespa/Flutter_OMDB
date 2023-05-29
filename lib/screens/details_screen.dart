import 'package:flutter/material.dart';
import 'package:flutter_http/data/model/movie_response.dart';
import 'package:flutter_http/data/repositories/details_repository.dart';
import 'package:flutter_http/screens/stores/details_store.dart';
import 'package:flutter_http/services/http_client.dart';

class DetailsScreen extends StatefulWidget {
  final String? id;

  const DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final DetailsStore store = DetailsStore(
    repository: DetailsRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getDetails(widget
        .id); // Chama a função do store que pega os dados de detalhes da API.
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
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  store.isLoading,
                  store.state,
                  store.error,
                ]),
                builder: (BuildContext context, Widget? child) {
                  if (store.isLoading.value == true) {
                    return SizedBox(
                      height: mediaQuery.height,
                      width: mediaQuery.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigoAccent,
                        ),
                      ),
                    );
                  } else if (store.error.value.isNotEmpty) {
                    return Center(
                      child: Text(store.error.value),
                    );
                  }
                  return Column(children: [
                    Text(
                      store.state.value?.Title ?? '',
                      style: TextStyle(fontSize: 28, color: Colors.white),
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
                            store.state.value?.Genre ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "IMDB: ${store.state.value?.imdbRating}",
                            style: TextStyle(
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
                        store.state.value?.Poster ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        store.state.value?.Type == "movie"
                            ? "${store.state.value?.Year} - ${store.state
                            .value?.Runtime} - ${store.state.value
                            ?.Language}"
                            : "${store.state.value?.Year} - ${store.state
                            .value?.Type}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        store.state.value?.Plot ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ]);
                }
              ),
            ),
          ),
        ));
  }
}
