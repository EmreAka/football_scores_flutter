import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LiveScoreService {
  Future<List<dynamic>> getLiveScores() async {
    final url = Uri.parse("http://localhost:5141/api/v1/events/live");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print((convert.jsonDecode(response.body)as List<dynamic>).length);
      print((convert.jsonDecode(response.body)as List<dynamic>)[0]['matches'].length);
      return convert.jsonDecode(response.body);
    }else{
      throw Exception("Can't fetch");
    }
  }

  Future<List<dynamic>> getTodaysEvents() async {
    final url = Uri.parse("http://localhost:5141/api/v1/events/today");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print((convert.jsonDecode(response.body)as List<dynamic>).length);
      print((convert.jsonDecode(response.body)as List<dynamic>)[0]['matches'].length);
      return convert.jsonDecode(response.body);
    }else{
      throw Exception("Can't fetch");
    }
  }
}