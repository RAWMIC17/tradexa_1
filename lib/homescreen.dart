import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tradexa_1/assets/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/movie.dart'; // Import the movie model
import 'models/genre.dart'; // Import the genre model

class HomescreenPage extends StatefulWidget {
  const HomescreenPage({super.key});

  @override
  State<HomescreenPage> createState() => _HomescreenPageState();
}

class _HomescreenPageState extends State<HomescreenPage> {
  TextEditingController _searchController = TextEditingController();
  List<MovieModel> movies = [];
  Map<int, String> genres = {};
  List<MovieModel> filteredMovies = [];
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _searchController.addListener(_filterMovies); 
  }

  Future<void> fetchMovies() async {
  const String omdbApiUrl =
      "http://www.omdbapi.com/?i=tt3896198&apikey=e2c62149";

  try {
    // Fetch data from OMDb API
    final response = await http.get(Uri.parse(omdbApiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Parse data into MovieModel
      final movie = MovieModel.fromJson(data);
      setState(() {
        movies = [movie];
        isLoading = false;
      });
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching movies: $e");
    setState(() {
      isLoading = false;
    });
  }
}

void _filterMovies() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredMovies = movies.where((movie) {
        return movie.title.toLowerCase().contains(query); // Filter based on title
      }).toList();
    });
  }

@override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Vx.gray200,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: "Home".text.fontFamily('Montserrat').semiBold.xl2.make(),
          ),
          backgroundColor: Vx.gray200,
          elevation: 0,
        ),
        body: Column(
          children: [ Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(fontFamily: 'Montserrat'),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  fillColor: Vx.gray200,
                  suffixIcon: Icon(
                    CupertinoIcons.search,
                    size: 24,
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide())
                ),
              ),
            ),
                        SizedBox(height: 15),
            isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          ):
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie=movies[index];
                return Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned(
                        left: 10,
                        top: 70,
                        child: Card(
                          elevation: 10,
                          shadowColor: Vx.black,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            width: MediaQuery.of(context).size.width - 30,
                            height: 150,
                            //color: Vx.orange500,
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width / 2 - 35,
                        top: 95,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          //color: Vx.green500,
                          width: 200,
                          //height: 88,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 220,
                                //color: Vx.blue500,
                                child: movie.title
                                    .text
                                    .bold
                                    .fontFamily('Montserrat')
                                    .xl
                                    .make(),
                              ),
                              SizedBox(height: 4),
                              Align(alignment: Alignment.centerLeft,
                                child: movie.genre
                                    .text
                                    .fontFamily('Montserrat')
                                    .light
                                    .sm
                                    .make(),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    color: double.parse(movie.imdbRating) < 7 ?Mycolors.blueColor:Mycolors.ratingColor,
                                  ),
                                  child: "${movie.imdbRating} IMDB"
                                      .text
                                      .color(Vx.white)
                                      .fontFamily('Montserrat')
                                      .light
                                      .sm
                                      .make(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22,
                        child: Container(height: 215,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Image.network(
                              movie.poster,
                              scale: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );}
              ),
            ),
          ],
        ),
      ),
    );
  }
}