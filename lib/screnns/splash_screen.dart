import 'dart:async';

import 'package:bitcoinnews/screnns/home_view.dart';
import 'package:bitcoinnews/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: 60),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/bitcoin.jpeg'),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Bitcoin Updates",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "Powered by Aamir",
                style: TextStyle(color: AppColors.secondaryColor),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }
}
