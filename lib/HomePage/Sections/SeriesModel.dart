class SeriesModel {
  final int id;
  final String name;
  final String posterPath;
  final String overview;
  final double voteAverage;

  SeriesModel({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    return SeriesModel(
      id: json['id'],
      name: json['name'],
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      overview: json['overview'],
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}