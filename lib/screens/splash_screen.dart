import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  String? _appVersion;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  Future<void> _loadAppVersion() async {
    final PackageInfo packageInfo;

    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 106, 23),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Cookbook',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lindseys Cookbook',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              _appVersion == null ? 'Version' : 'Version $_appVersion',
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
