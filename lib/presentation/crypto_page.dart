import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../core/di/injection.dart';
import '../data/websocket_service.dart';

// --- LOGIKA PERSONAL ---
int calculateTax(int nimAkhir) {
  int total = 0;
  int limit = nimAkhir * 10000000; 
  for (int i = 0; i < limit; i++) {
    total += 1;
  }
  return total;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late final WebSocketService _wsService;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _wsService = locator<WebSocketService>();
    _wsService.connect();
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F5),
      appBar: AppBar(
        title: const Text('Live Crypto (BTC)'),
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
        elevation: 0, 
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<String>(
                stream: _wsService.priceStream,
                builder: (context, snapshot) {
                  // --- LOADING AWAL STREAM ---
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Color(0xFFF48FB1));
                  }
                  
                  // --- JIKA TERJADI ERROR KONEKSI ---
                  if (snapshot.hasError) {
                    return Text(
                      'Error Koneksi:\n${snapshot.error}', 
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  
                  // --- JIKA DATA KOSONG ---
                  if (!snapshot.hasData) {
                    return const Text('Menunggu data dari server...');
                  }

                  final price = snapshot.data;

                  // --- KARTU CRYPTO (UI BARU) ---
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF48FB1).withOpacity(0.3), // Bayangan pink
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.currency_bitcoin, size: 80, color: Colors.orange),
                        const SizedBox(height: 16),
                        const Text(
                          'Harga Bitcoin Real-time', 
                          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)
                        ),
                        const SizedBox(height: 8),
                        
                        // LOGIKA PENGHILANG $null
                        (price == null || price == "MENUNGGU")
                          ? const Column(
                              children: [
                                SizedBox(height: 16),
                                CircularProgressIndicator(color: Color(0xFFF48FB1)),
                                SizedBox(height: 16),
                                Text('Menunggu pergerakan pasar...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            )
                          : Text(
                              '\$$price',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF48FB1),
                              ),
                            ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),

              // --- TOMBOL KALKULASI PAJAK ---
              SizedBox(
                width: double.infinity,
                height: 55, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48FB1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: const Color(0xFFF48FB1).withOpacity(0.5),
                  ),
                  onPressed: _isCalculating ? null : () async {
                    setState(() {
                      _isCalculating = true;
                    });

                    int duaDigitNim = 42; 
                    int result = await compute(calculateTax, duaDigitNim);

                    setState(() {
                      _isCalculating = false;
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Kalkulasi Selesai! Hasil loop: $result', 
                            textAlign: TextAlign.center, 
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                          backgroundColor: const Color(0xFFF48FB1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          margin: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                        ),
                      );
                    }
                  },
                  child: _isCalculating 
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
                            SizedBox(width: 12),
                            Text('Menghitung berat...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        )
                      : const Text('Kalkulasi Pajak Kripto (Isolate)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}