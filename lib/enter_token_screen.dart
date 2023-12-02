import 'dart:io';

import 'package:carewatch_app_wearos/token_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'home_watch.dart';

class EnterTokenScreen extends StatefulWidget {
  @override
  _EnterTokenScreenState createState() => _EnterTokenScreenState();
}

class _EnterTokenScreenState extends State<EnterTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfPaired();
  }

  Future<void> _checkIfPaired() async {
    final prefs = await SharedPreferences.getInstance();
    final isPaired = prefs.getBool('isPaired') ?? false;
    final savedToken = prefs.getString('token'); 

    if (isPaired && savedToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeWatch(token: savedToken),
        ),
      );
    }
  }

  Future<String> getDeviceName() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model ?? "Desconocido"; 
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine ?? "Desconocido"; 
    }
    return "Plataforma no soportada";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/justLogo.png', // Reemplaza con tu imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Genera un token de vinculación en la aplicación móvil',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30), 
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _tokenController,
                      decoration: InputDecoration(
                        label: const Text('Token'),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.deepPurple, 
                            width: 2.0, 
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.deepPurple.withOpacity(0.5), 
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.deepPurple, 
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: 
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            String smartwatchName = "SM R860 Smartwatch Samsung";

                            final prefs = await SharedPreferences.getInstance();
                            //await prefs.setString('deviceName', deviceName);

                            final tokenService = TokenService();
                            final smartwatchId = await tokenService.getSmartwatchIdByToken(_tokenController.text);
                            await tokenService.updateSmartwatchConnection(smartwatchId, smartwatchName); 

                            await prefs.setBool('isPaired', true);
                            await prefs.setString('token', _tokenController.text);
                            await prefs.setInt("smartwatchId", smartwatchId);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeWatch(token: _tokenController.text),
                              ),
                            );
                          } catch (e) {
                            // Manejar errores aquí
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Vincular'),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
