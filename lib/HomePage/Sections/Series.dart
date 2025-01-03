import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Series extends StatefulWidget{
  const Series({super.key});

  @override
  State<Series> createState()=> _MyWidgetState();
}

class _MyWidgetState extends State<Series>{
  List<dynamic> movies = [];
  bool isLoading = true;

  // Replace with your actual TMDB API key
  final String apiKey = '549c475ef82621dc249692526f2ff2cd';
  final String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  void initState() {
    super.initState();
    fetchWeeklyPopularMovies();
  }

  Future<void> fetchWeeklyPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/trending/tv/day?api_key=549c475ef82621dc249692526f2ff2cd'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          movies = data['results'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Series This Week'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(movie: movie, baseImageUrl: baseImageUrl);
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic movie;
  final String baseImageUrl;

  const MovieCard({
    super.key,
    required this.movie,
    required this.baseImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie, baseImageUrl: baseImageUrl),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      baseImageUrl + (movie['poster_path'] ?? ''),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Rating: ${movie['vote_average']?.toStringAsFixed(1) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final dynamic movie;
  final String baseImageUrl;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.baseImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title'] ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                baseImageUrl + (movie['backdrop_path'] ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Rating: ${movie['vote_average']?.toStringAsFixed(1) ?? 'N/A'} (${movie['vote_count']} votes)'),
                  const SizedBox(height: 16),
                  Text(movie['overview'] ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}