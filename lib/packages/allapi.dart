import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/movie.dart';


class AllApi {
  static const upcomingMovies = '/movie/upcoming';
  static const apiKey = '5f3adfbfe7666f478fbb79c6b2d9cabc';
  static const baseUrl = 'https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1';

  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/upcoming'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      } else {
        throw Exception('Failed to load upcoming movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUpcomingMovies: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint?api_key=$apiKey');
      debugPrint('Fetching data from: $url');
      
      final response = await http.get(url);

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchData: $e');
      rethrow;
    }
  }
} 