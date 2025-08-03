import 'package:flutter/material.dart';
import 'dart:async';

class PaleeScreen extends StatefulWidget {
  const PaleeScreen({super.key});

  @override
  State<PaleeScreen> createState() => _PaleeScreenState();
}

class _PaleeScreenState extends State<PaleeScreen> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedDateTime {
    return "${_now.year.toString().padLeft(4, '0')}"
        "/${_now.month.toString().padLeft(2, '0')}"
        "/${_now.day.toString().padLeft(2, '0')} "
        "${_now.hour.toString().padLeft(2, '0')}:"
        "${_now.minute.toString().padLeft(2, '0')}:"
        "${_now.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/abc.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formattedDateTime,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
