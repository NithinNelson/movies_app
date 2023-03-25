import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies_app/services/rapi_data.dart';
import 'package:movies_app/services/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetails extends StatefulWidget {
  final int id;
  const MovieDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  var movieDetails;
  bool loader = false;

  @override
  void initState() {
    setState(() {
      loader = true;
    });
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    await getMovieDetails(widget.id, context);
    await _getMdetails().then((value) {
      setState(() {
        loader = false;
      });
    });
  }

  Future<void> _getMdetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? moviedata = prefs.getString('movieDetails');
    if (moviedata != null) {
      setState(() {
        movieDetails = json.decode(moviedata);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loader ? "" : movieDetails['title'],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          maxLines: 1,
        ),
      ),
      body: loader
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Colors.white),
              child: const Center(
                child: SpinKitFadingCircle(
                  color: Colors.purple,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Card(
                        elevation: 5,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 300,
                          child: Image.network(movieDetails['image'],
                              fit: BoxFit.cover, loadingBuilder: imageLoading),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 300,
                          child: Text(
                            movieDetails['title'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieDetails['genre'].length,
                          itemBuilder: (context, intx) {
                            return Padding(
                              padding: const EdgeInsets.all(3),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        const Color.fromRGBO(220, 220, 220, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: const BorderSide(
                                        color: Colors.greenAccent)),
                                child: Text(
                                  movieDetails['genre'][intx]['name'],
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 12),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 5),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        children: [
                          const TextSpan(text: '                      '),
                          TextSpan(text: movieDetails['description']),
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Text(
                          "Release Date : ${movieDetails['releaseDate']}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Cast",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 500.h,
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                          itemCount: movieDetails['cast'].length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1 / 1.6,
                          ),
                          itemBuilder: (ctx, index) {
                            return Container(
                              height: 300.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    elevation: 0,
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SizedBox(
                                        height: 145.h,
                                        child: movieDetails['cast'][index]
                                                    ['profile_path'] !=
                                                null
                                            ? Image.network(
                                                "https://image.tmdb.org/t/p/original${movieDetails['cast'][index]['profile_path']}",
                                                fit: BoxFit.cover,
                                                loadingBuilder: imageLoading)
                                            : Center(
                                              child: Text(
                                                "Empty",
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 10),
                                                maxLines: 1,
                                              ),
                                            )),
                                  ),
                                  SizedBox(
                                    width: 90.w,
                                    child: Text(
                                      movieDetails['cast'][index]['known_for_department'],
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 10),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 90.w,
                                    child: Text(
                                      movieDetails['cast'][index]['name'],
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 10),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
