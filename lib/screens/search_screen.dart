import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_http/components/error_pattern.dart';
import 'package:flutter_http/components/loading.dart';
import 'package:flutter_http/components/movie_card.dart';
import 'package:flutter_http/data/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_http/data/bloc/movies_bloc/movies_event.dart';
import 'package:flutter_http/data/bloc/movies_bloc/movies_state.dart';
import 'package:flutter_http/data/repositories/movies_repository.dart';
import 'package:flutter_http/screens/details_screen.dart';
import 'package:flutter_http/services/http_client.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  late final MoviesBloc _moviesBloc;

  @override
  void initState() {
    _moviesBloc = MoviesBloc(
      repository: MoviesRepository(
        client: HttpClient(),
      ),
    );
    super.initState();
  }

  Timer? _debounce; //Cria uma variável para atribuir o delay do Timer.

  _onSearchChanged(String search) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), () {
      _moviesBloc.add(
        GetMovies(
          search: search,
        ),
      ); //Faz a chamada a api através do BLoC uma única vez após 1,5 segundos da alteração do texto
    });
  }

  @override
  void dispose() {
    super.dispose();
    _moviesBloc.close();
    _debounce?.cancel();
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
                      hintStyle:
                          const TextStyle(color: Colors.white54, fontSize: 18)),
                ),
              ),
              Expanded(
                child: BlocBuilder<MoviesBloc, MoviesState>(
                  bloc: _moviesBloc,
                  builder: (context, state) {
                    if (state is MoviesInitialState) {
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
                    } else if (state is MoviesLoadingState) {
                      return const Loading();
                    } else if (state is MoviesNotFoundErrorState) {
                      return const ErrorPattern(errorText: "Movie not found",);
                    } else if (state is MoviesLoadedState) {
                      final list = state?.movies;

                      return CustomScrollView(slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return InkWell(
                                  child: MovieCard(
                                    movie: list?[index],
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        id: list?[index].imdbID,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: list?.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: (mediaQuery.width) /
                                  (mediaQuery.height * 0.901),
                            ),
                          ),
                        ),
                      ]);
                    }
                      return const ErrorPattern(errorText: "Unknown error",);
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
