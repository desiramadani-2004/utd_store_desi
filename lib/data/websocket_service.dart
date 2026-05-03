import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  WebSocketChannel? _channel;

  // Fungsi untuk menyambungkan "antena" ke server Binance
  void connect() {
    // URL WebSocket publik Binance untuk harga Bitcoin (BTC) ke USDT
    final wsUrl = Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@ticker');
    _channel = WebSocketChannel.connect(wsUrl);
  }

  // Stream ini yang akan kita dengarkan di UI nanti agar angkanya gerak-gerak
  Stream<Map<String, dynamic>> get cryptoStream {
    if (_channel == null) {
      throw Exception("WebSocket belum terkoneksi. Panggil connect() dulu.");
    }
    
    // Mengubah data teks (JSON) dari server menjadi Map yang bisa dibaca Flutter
    return _channel!.stream.map((event) {
      return jsonDecode(event) as Map<String, dynamic>;
    });
  }

  // Fungsi untuk memutus koneksi saat halaman ditutup (Sangat penting agar tidak boros kuota/memori)
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}