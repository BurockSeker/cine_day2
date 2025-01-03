import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;

import '../apilinks/allapi.dart';
import 'Sections/Movies.dart';
import 'Sections/Series.dart';
import 'Sections/Upcoming.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trendinglist = [];
  int uval = 1;
  bool isLoading = true;
  String errorMessage = '';
  late final httpClient.Client client;

  @override
  void initState() {
    super.initState();
    client = httpClient.Client();
    print("initState called");
    loadData();
  }

  void switchTrending(int value) {
    setState(() {
      uval = value;
      trendinglist.clear();
      isLoading = true;
    });
    loadData();
  }

  Future<void> loadData() async {
    try {
      print("Starting data load for ${uval == 1 ? 'weekly' : 'daily'} trending");
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      String apiUrl = uval == 1 ? popularweekly : populardaily;
      print("Using API URL: $apiUrl");

      final response = await httpClient.get(Uri.parse(apiUrl));
      print("Response status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        await trendinglisthome();
      } else {
        throw Exception("API returned ${response.statusCode}");
      }
      
      setState(() {
        isLoading = false;
      });
      
    } catch (e) {
      print("Error in loadData: $e");
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: $e';
      });
    }
  }

  Future<void> trendinglisthome() async {
    try {
      String apiUrl = uval == 1 ? popularweekly : populardaily;
      print("Fetching ${uval == 1 ? 'weekly' : 'daily'} trending data...");
      
      final response = await httpClient.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        print("Received ${results.length} items");
        
        setState(() {
          trendinglist = results.map((item) => {
            'id': item['id'],
            'poster_path': item['poster_path'],
            'vote_average': item['vote_average'],
            'media_type': item['media_type'],
            'indexno': trendinglist.length,
          }).toList();
        });
        
        print("Trending list updated with ${trendinglist.length} items");
      } else {
        throw Exception("API returned ${response.statusCode}");
      }
    } catch (e) {
      print("Error in trendinglisthome: $e");
      rethrow;
    }
  }

  Future<void> testAPI() async {
    try {
      print("Testing API connection...");
      print("API Key: ${apikey.substring(0, 4)}..."); // Only show first 4 chars for security
      print("Weekly URL: $popularweekly");
      
      final response = await httpClient.get(Uri.parse(popularweekly));
      print("Response status: ${response.statusCode}");
      print("Response body preview: ${response.body.substring(0, 100)}");
    } catch (e) {
      print("API Test Error: $e");
    }
  }

  get http => null;

  @override
  Widget build(BuildContext context) {
    TabController _tabcontroller=TabController(length: 3, vsync: this);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => switchTrending(1),
                    child: Text(
                      'Weekly',
                      style: TextStyle(
                        color: uval == 1 ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => switchTrending(2),
                    child: Text(
                      'Daily',
                      style: TextStyle(
                        color: uval == 2 ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Builder(
                builder: (context) {
                  if (isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading ${uval == 1 ? 'weekly' : 'daily'} trending content...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }

                  if (errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (trendinglist.isEmpty) {
                    return Center(
                      child: Text(
                        'No content available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      height: MediaQuery.of(context).size.height,
                    ),
                    items: trendinglist.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken,
                                ),
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${item['poster_path']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Text("CineDay🎬"),
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                    physics:BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabcontroller,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:Colors.red.withOpacity(0.4),
                    ),
                    tabs: [
                      Tab(child: Text('Movies')),
                      Tab(child: Text('Series')),
                      Tab(child: Text('Upcoming'))

                    ]
                  )
                ),
                Container(
                  height: 1050,
                  child: TabBarView(
                    controller: _tabcontroller,
                    children: [
                      Movies(),
                      Series(),
                      Upcoming(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }
}
