// reminder_watch.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'details_reminder_watch.dart';  // Importa el archivo de detalles aquí

class ReminderWatch extends StatefulWidget {
  @override
  _ReminderWatchState createState() => _ReminderWatchState();
}

class _ReminderWatchState extends State<ReminderWatch> {
  bool isSwitched = false;
  late String _timeString;
  late Timer _timer;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset(
                'assets/capsulas.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '$_timeString',
                    style: GoogleFonts.montserrat(
                      fontSize: 35, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomSwitch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                    if (value) {  // Si el switch se activa, navega a la pantalla de detalles
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsReminderWatch()),
                      ).then((_) {
                        // Esto se ejecuta cuando regresas de la pantalla DetailsReminderWatch
                        setState(() {
                          isSwitched = false; // Restablece el estado del switch
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? const Color.fromARGB(255, 33, 156, 243) : Colors.grey,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 27,
              height: 27,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
