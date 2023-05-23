import 'package:flutter/material.dart';
import 'package:flutter_http/data/model/movie_response.dart';

class MovieCard extends StatelessWidget {
  final MovieResponse? movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Container(
            width: mediaQuery.width * 0.4,
            height: mediaQuery.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                movie?.Poster ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigoAccent,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration:
                        const BoxDecoration(color: Color.fromRGBO(45, 45, 45, 0.1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.broken_image_rounded,
                          size: 50,
                          color: Colors.white54,
                        ),
                        Text(
                          'Image not found',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: SizedBox(
              width: mediaQuery.width * 0.45,
              height: mediaQuery.height *0.045,
              child: Center(
                child: Text(
                  movie?.Title ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
