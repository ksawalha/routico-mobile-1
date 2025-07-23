import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gem_kit/core.dart' as gem;
import 'package:gem_kit/map.dart' as gem;
import 'package:gem_kit/navigation.dart' as gem;
import 'package:gem_kit/routing.dart' as gem;
import 'package:gem_kit/sense.dart' as gem;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:collection/collection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'login.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(home: LocationPage());
}

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
  
}

class _LocationPageState extends State<LocationPage> {
  String location = 'Press button to get location';

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    gem.GemKit.initialize(appAuthorization: 'eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJlZTkyMWMwYi05ODAyLTRhZWEtODI3OS1hYjJkNzBhY2Q1MzkiLCJleHAiOjE3Njg5MDI4NjYsImlzcyI6Ik1hZ2ljIExhbmUiLCJqdGkiOiI3YWJiMDRkZS1lZjAxLTRiMjYtOTNhYS0zZGQ5ZTczMzhkZjYifQ.24S_NXRmbh0nFJ2lv_4dZ4QAMG-BH2c73ZzoyNQByhRvr1HEvZEIuuOiRYtZQGstTbH6h3zuEvQG4oI_JjUXrQ');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location =
            'Location permissions are permanently denied. Please enable them from settings.';
      });
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      location = 'Lat: ${pos.latitude}, Lon: ${pos.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location with Permission')),
      body: Center(child: Text(location)),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
