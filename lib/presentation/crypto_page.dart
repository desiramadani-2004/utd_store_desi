import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../core/di/injection.dart';
import '../data/websocket_service.dart';

// --- LOGIKA PERSONAL (Anti-AI) Poin 4 ---
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Map<String, dynamic>>(
              stream: _wsService.cryptoStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Color(0xFFF48FB1));
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('Menunggu data dari server...');
                }

                final data = snapshot.data!;
                
                // JURUS ANTI-GAGAL: Cari harga pakai kunci 'bitcoin' (CoinCap) atau 'p' (Binance)
                final price = data['bitcoin']?.toString() ?? data['p']?.toString();

                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.currency_bitcoin, size: 80, color: Colors.orange),
                        const SizedBox(height: 16),
                        const Text('Harga Bitcoin Real-time', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        
                        price == null 
                          ? Column(
                              children: [
                                const SizedBox(height: 16),
                                const CircularProgressIndicator(color: Color(0xFFF48FB1)),
                                const SizedBox(height: 8),
                                const Text('Menunggu pergerakan pasar...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 16),
                                // ALAT DETEKTIF: Munculkan data asli dari server kalau formatnya aneh
                                Text('Log Server: $data', style: const TextStyle(fontSize: 10, color: Colors.red), textAlign: TextAlign.center),
                              ],
                            )
                          : Text(
                              '\$$price',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF48FB1),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF48FB1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                      content: Text('Kalkulasi Selesai! Hasil loop: $result'),
                      backgroundColor: const Color(0xFFF48FB1),
                    ),
                  );
                }
              },
              child: _isCalculating 
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 8),
                        Text('Menghitung berat...')
                      ],
                    )
                  : const Text('Kalkulasi Pajak Kripto'),
            ),
          ],
        ),
      ),
    );
  }
}