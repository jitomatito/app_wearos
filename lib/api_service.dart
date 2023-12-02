// api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  


Future<Map<String, dynamic>> getUserDetails(String token) async {
    var url = Uri.parse('https://api.carewatch-en-equipo.com/smartwatch/tokenAccount/$token');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print('Respuesta del servidor en getUserDetails: ${response.body}');  // Depuración
      return json.decode(response.body)['userGroup']['user'];
    } else {
      print('Error en getUserDetails: ${response.statusCode}, Respuesta: ${response.body}');  // Depuración
      throw Exception('Failed to load user details');
    }
  }

  Future<Map<String, dynamic>> getUserDetailsBySmartwatchId(int smartwatchId) async {
    var url = Uri.parse('https://api.carewatch-en-equipo.com/smartwatch/$smartwatchId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user details for smartwatch ID: $smartwatchId');
    }
  }

  Future<bool> deleteBySmartwatchId(int smartwatchId) async {
    var url = Uri.parse('https://api.carewatch-en-equipo.com/smartwatch/$smartwatchId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load user details for smartwatch ID: $smartwatchId');
    }
  }

}
