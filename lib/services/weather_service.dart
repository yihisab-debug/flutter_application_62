import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = '377c433f30614cc8a3e54452260203';
const String baseUrl = 'https://api.weatherapi.com/v1';

class WeatherService {
  static Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=7&lang=ru'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Не удалось загрузить погоду');
    }
  }
}