import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movies_app/models.dart';
import 'package:movies_app/utils/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getRapi(context) async {
  List<ListModel> movies = [];

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=4ba3b19b3c7d232ee73583c936940fcc&language=en-US&page={page}",
      ),
    );

    if (response.statusCode == 200) {
      var movieList = json.decode(response.body);
      if (movieList['results'] != null && movieList['results'].isNotEmpty) {
        movieList['results'].forEach((movie) {
          movies.add(
            ListModel(
                id: movie['id'],
                title: movie['original_title'],
                image: "https://image.tmdb.org/t/p/original${movie['poster_path']}",
                releaseDate: movie['release_date'],
                vote: movie['vote_average'].toString()),
          );
        });

        await prefs.setString('movieData',
            json.encode(movies.map((movie) => movie.toJson()).toList()));
      }
    } else {
      snackBar(context, "Data Not Found");
    }
  } on SocketException catch (e) {
    snackBar(context, "Connection Problem");
  } catch (e) {
    snackBar(context, e.toString());
  }
}

Future<void> getMovieDetails(id, context) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse(
        "https://api.themoviedb.org/3/movie/$id?api_key=4ba3b19b3c7d232ee73583c936940fcc&language=en-US",
      ),
    );

    var castResp = await http.get(
      Uri.parse(
        "https://api.themoviedb.org/3/movie/$id/credits?api_key=4ba3b19b3c7d232ee73583c936940fcc&language=en-US",
      ),
    );

    if (response.statusCode == 200 && castResp.statusCode == 200) {
      var movieDetails = json.decode(response.body);
      var cast = json.decode(castResp.body);

      var data = MovieDetails(
          title: movieDetails['original_title'],
          image:
              "https://image.tmdb.org/t/p/original${movieDetails['poster_path']}",
          description: movieDetails['overview'],
          genre: movieDetails['genres'],
          releaseDate: movieDetails['release_date'],
          cast: cast['cast']);

      await prefs.setString('movieDetails', json.encode(data.toJson()));
    } else {
      snackBar(context, "Data Not Found");
    }
  } on SocketException catch (e) {
    snackBar(context, "Connection Problem");
  } catch (e) {
    snackBar(context, e.toString());
  }
}
