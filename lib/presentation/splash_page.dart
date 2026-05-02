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
    // Memanggil aturan bisnis dari layer Domain (Delay 2 detik)
    final delayInSeconds = GetSplashDelay().execute();
    
    // Menunggu sesuai durasi yang ditentukan di layer Domain
    await Future.delayed(Duration(seconds: delayInSeconds));
    
    // Navigasi ke halaman Home menggunakan go_router
    if (mounted) {
      context.go('/home'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8BBD0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Toko
            const Icon(Icons.storefront, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            
            // --- NAMA LENGKAP ---
            const Text(
              'Desi Ramadani', 
              style: TextStyle(
                fontSize: 26, 
                color: Colors.white, 
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // --- NIM ---
            const Text(
              'NIM: 20123042', 
              style: TextStyle(
                fontSize: 18, 
                color: Colors.white70, 
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Animasi Loading
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            
            const Text(
              'Loading...',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}