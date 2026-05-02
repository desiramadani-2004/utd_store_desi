import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/get_splash_delay.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() async {
    // Memanggil aturan bisnis (Logika Personal) dari layer Domain
    final delayInSeconds = GetSplashDelay().execute();
    
    // Menunggu sesuai detik NIM
    await Future.delayed(Duration(seconds: delayInSeconds));
    
    // Karena halaman Home belum ada, kita tampilkan pesan pop-up sementara
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Navigasi ke Home (Akan dibuat di Step 3)')),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'UTD Store Desi',
              style: TextStyle(
                fontSize: 28, 
                color: Colors.white, 
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}