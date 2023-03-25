import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies_app/screens/login.dart';
import 'package:movies_app/screens/movie_details.dart';
import 'package:movies_app/services/rapi_data.dart';
import 'package:movies_app/services/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  var newResult = [];
  var movieList;
  String? lohIn;
  bool loader = false;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    setState(() {
      loader = true;
    });
    await getRapi(context);
    _getMovieList();
    setState(() {
      loader = false;
    });
  }

  Future<void> refresh() async {
    _getData();
  }

  _getMovieList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? moviedata = prefs.getString('movieData');
    final String? login = prefs.getString('login');
    if (moviedata != null) {
      setState(() {
        movieList = json.decode(moviedata);
        lohIn = login;
        newResult = movieList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text(
          "Popular Movies",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          maxLines: 1,
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Text(
                "Hi, $lohIn",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                maxLines: 1,
              ),
              SizedBox(height: 300.h),
              InkWell(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('login');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return Login();
                  }), (route) => false);
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Logout",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      maxLines: 1,
                    ),
                  ),
                ),
              )
            ],
          ),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 290,
                      height: 40,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Search movie',
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 15),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: controller.text.isNotEmpty
                                  ? Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    )
                                  : Container(),
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                  //newResult.clear();
                                  newResult = movieList;
                                });
                                // onSearchTextChanged('');
                              },
                            ),
                            counterText: ""),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        maxLength: 15,
                        onChanged: (value) {
                          setState(() {
                            newResult = movieList
                                .where((element) => element["title"]
                                    .toString()
                                    .toUpperCase()
                                    .contains(value.toUpperCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.purple[100]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: RefreshIndicator(
                        onRefresh: refresh,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: newResult.length,
                          padding: const EdgeInsets.only(bottom: 150, top: 10),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return MovieDetails(
                                        id: newResult[index]['id']);
                                  })),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: Card(
                                      elevation: 5,
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Card(
                                            elevation: 0,
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: SizedBox(
                                              width: 100,
                                              child: Image.network(
                                                  newResult[index]['image'],
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      imageLoading),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 200.w,
                                                  child: Text(
                                                    newResult[index]['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.brown,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  "Release Date : ${newResult[index]['releaseDate']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  width: 190.w,
                                                  // color: Colors.red,
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/star.png",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "${newResult[index]['vote']}/10",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10)
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
