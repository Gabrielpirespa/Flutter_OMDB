import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_http/components/movie_card.dart';
import 'package:flutter_http/data/repositories/movies_repository.dart';
import 'package:flutter_http/screens/details_screen.dart';
import 'package:flutter_http/screens/stores/movie_store.dart';
import 'package:flutter_http/services/http_client.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final MovieStore store = MovieStore(
    //Instância da store.
    repository: MoviesRepository(
      client: HttpClient(),
    ),
  );

  Timer? _debounce; //Cria uma variável para atribuir o delay do Timer.

  _onSearchChanged(String search) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), () {
      store.getMovies(search); //Faz a chamada a api uma única vez após 1,5 segundos da alteração do texto
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
        body: Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            right: 30,
            left: 30,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  cursorWidth: 1,
                  cursorColor: Colors.white54,
                  textAlign: TextAlign.center,
                  onChanged: (String search) {
                    if (search.length >= 3) {
                      search = searchController.text;
                      _onSearchChanged(search);
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        color: Colors.white54,
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(45, 45, 45, 0.1),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "Search a movie",
                      hintStyle: const TextStyle(color: Colors.white54, fontSize: 18)),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  //Como existem três variáves reativas passamos a lista delas no animation com o Listenable.merge.
                  animation: Listenable.merge([
                    store.isLoading,
                    store.error,
                    store.state,
                  ]),
                  builder: (BuildContext context, Widget? child) {
                    if (store.isLoading.value == true) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigoAccent,
                        ),
                      );
                    } else if (store.error.value.isNotEmpty) {
                      return Center(
                        child: Text(store.error.value),
                      );
                    } else if (store.state?.value == null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline_rounded, color: Colors.white, size: 70,),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Movie not found",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (store.state?.value != null) {
                      if (store.state!.value!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Search for a Movie in the IMDB database",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    }
                    return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 14, bottom: 8),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return InkWell(
                                child: MovieCard(
                                  movie: store.state?.value?[index],
                                ),
                                onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => DetailsScreen(id: store.state?.value?[index].imdbID,))),
                              );
                            },
                            childCount: store.state?.value?.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 0,
                            childAspectRatio: (mediaQuery.width)/(mediaQuery.height * 0.901),
                          ),
                        ),
                      ),
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
