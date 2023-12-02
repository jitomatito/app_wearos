import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsReminderWatch extends StatefulWidget {
  @override
  _DetailsReminderWatchState createState() => _DetailsReminderWatchState();
}

class _DetailsReminderWatchState extends State<DetailsReminderWatch> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.8,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: [
                // Primer card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple
                      ], // Gradiente de colores
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.purple.withOpacity(0.2),
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Text(
                            '2 pastillas',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            'Ibuprofeno',
                            textAlign: TextAlign.center,
                            style: 
                            GoogleFonts.montserrat(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Segundo card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple
                      ], // Gradiente de colores
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.purple.withOpacity(0.2),
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        'Ingerir después de alimentos',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_currentIndex == 0)
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_drop_down,
                    size: 50,
                    color: Colors.white, // Ícono blanco para mejor visibilidad
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
