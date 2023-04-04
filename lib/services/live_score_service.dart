import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LiveScoreService {
  Future<List<dynamic>> getLiveScores() async {
    final url = Uri.parse("https://nestfootball.emreaka.tech/api/v1/events/live");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print((convert.jsonDecode(response.body)as List<dynamic>).length);
      return convert.jsonDecode(response.body);
    }else{
      throw Exception("Can't fetch");
    }
  }
}