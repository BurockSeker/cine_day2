import 'dart:convert';

import '../models/series_model.dart';

class AllApi {
  static get http => null;

  static Future<List<SeriesModel>> getPopularSeries() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/tv/popular?api_key=YOUR_API_KEY'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => SeriesModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load popular series');
    }
  }
}