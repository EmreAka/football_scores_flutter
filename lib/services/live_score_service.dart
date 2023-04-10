import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LiveScoreService {

  String url = "http://api.emreaka.tech/api/v1/";

  Future<List<dynamic>> getLiveScores() async {
    final url = Uri.parse("${this.url}events/live");
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
    final url = Uri.parse("${this.url}events/today");
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