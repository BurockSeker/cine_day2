const String apikey = "549c475ef82621dc249692526f2ff2cd";
const String baseurl = "https://api.themoviedb.org/3";
const String popularweekly = "$baseurl/trending/all/week?api_key=$apikey";
const String populardaily = "$baseurl/trending/all/day?api_key=$apikey";
String popularseries='https://api.themoviedb.org/3/trending/tv/day?api_key=549c475ef82621dc249692526f2ff2cd';
String upcomingmovies='https://api.themoviedb.org/3/movie/upcoming?api_key=549c475ef82621dc249692526f2ff2cd';

Future<bool> testAPIConnection() async {
  try {
    var http;
    final response = await http.get(Uri.parse(popularweekly));
    print("API Test - Status Code: ${response.statusCode}");
    print("API Test - Response: ${response.body.substring(0, 100)}...");
    return response.statusCode == 200;
  } catch (e) {
    print("API Test Error: $e");
    return false;
  }
}
