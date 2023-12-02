import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenService {
  // Método para obtener el ID del smartwatch usando el token
  Future<int> getSmartwatchIdByToken(String token) async {
    var url = Uri.parse('https://api.carewatch-en-equipo.com/smartwatch/tokenAccount/$token');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['id'];
    } else {
      throw Exception('Error al obtener el ID del smartwatch: ${response.statusCode}');
    }
  }

  Future<void> updateSmartwatchConnection(int smartwatchId, String smartwatchName) async {
    var url = Uri.parse('https://api.carewatch-en-equipo.com/smartwatch/$smartwatchId');
    var body = jsonEncode({
      'isConnected': true,
      'smartwatchName': smartwatchName,
    });
    var response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      print('Respuesta del servidor: ${response.body}');  
    } else {
      print('Error al actualizar: ${response.statusCode}, Respuesta: ${response.body}');  
      throw Exception('Error al actualizar el estado de conexión del smartwatch: ${response.statusCode}');
    }
  }
}
