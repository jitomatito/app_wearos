// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:carewatch_app_wearos/enter_token_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reminder_watch.dart';
import 'api_service.dart';

class HomeWatch extends StatefulWidget {
    final String token;

  HomeWatch({required this.token});

  @override
  _HomeWatchState createState() => _HomeWatchState();
}

class _HomeWatchState extends State<HomeWatch> {
  late Future<Map<String, dynamic>> userDetailsFuture;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    userDetailsFuture = apiService.getUserDetails(widget.token);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/justLogo.png',
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
                const SizedBox(height: 20),
                FutureBuilder<Map<String, dynamic>>(
                  future: userDetailsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No data'));
                    } else {
                      final userDetails = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.width - 40.0,
                            viewportFraction: 1.2,
                          ),
                          items: [
                            userDetails['name'],
                            userDetails['lastName'],
                            userDetails['email'],
                            userDetails['phone']
                          ].map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width -
                                        40.0,
                                    height: MediaQuery.of(context).size.width -
                                        40.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item ?? 'Valor por defecto',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15, color: Colors.black),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    )
                                );
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),   
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {

                    final apiService = ApiService();

                    final prefs = await SharedPreferences.getInstance();
                    final smartwatchId = prefs.getInt('smartwatchId') ?? 0;

                    bool seElimino = await apiService.deleteBySmartwatchId(smartwatchId);

                    if (seElimino) {

                      await prefs.remove("isPaired");
                      await prefs.remove("token");
                      await prefs.remove("smartwatchId");


                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterTokenScreen()
                        ),
                      );

                    }


                  }, 
                  child: Text("Desvincular")
                ),              
                SizedBox(
                    height: MediaQuery.of(context).size.height / 2 - 70.0 / 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 75),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReminderWatch()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      child: const Text('Reminder'),
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
