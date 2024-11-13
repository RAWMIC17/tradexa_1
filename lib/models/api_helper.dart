import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tradexa_1/models/genre.dart';
import 'package:tradexa_1/models/movie.dart';

Future<List<MovieModel>> fetchTrendingMovies() async {
  const url = 'https://api.themoviedb.org/3/trending/movie/day?language=en-US';
  const String bearerToken =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMDliNzA0Zjk2OWU2YmNjYTQ3NDU2NDRmYjkxMWYzMyIsIm5iZiI6MTczMTQ0NTk5NC45NjA2ODIsInN1YiI6IjY3MzNiYmVlMDU4MTY0YzQwNTIzZTg2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.aZx3BxWm_LpTYRvLVaAWHlHk999IqfBfbjcIisnJap0';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': bearerToken,
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['results'] as List)
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  } else {
    throw Exception('Failed to load trending movies');
  }
}

Future<GenreModel> fetchGenres() async {
  const url = 'https://api.themoviedb.org/3/genre/movie/list?language=en-US';
  const String bearerToken =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMDliNzA0Zjk2OWU2YmNjYTQ3NDU2NDRmYjkxMWYzMyIsIm5iZiI6MTczMTQ0NTk5NC45NjA2ODIsInN1YiI6IjY3MzNiYmVlMDU4MTY0YzQwNTIzZTg2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.aZx3BxWm_LpTYRvLVaAWHlHk999IqfBfbjcIisnJap0';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': bearerToken,
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return GenreModel.fromJson(data);
  } else {
    throw Exception('Failed to load genres');
  }
}

List<String> resolveGenres(List<int> genreIds, List<Genre> genres) {
  final genreMap = {for (var genre in genres) genre.id: genre.name};
  return genreIds.map((id) => genreMap[id] ?? 'Unknown').toList();
}
