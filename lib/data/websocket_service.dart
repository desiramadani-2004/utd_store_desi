import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  WebSocketChannel? _channel;

  void connect() {
    final wsUrl = Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@trade');
    _channel = WebSocketChannel.connect(wsUrl);
  }

  Stream<Map<String, dynamic>> get cryptoStream {
    if (_channel == null) {
      throw Exception("WebSocket belum terkoneksi.");
    }
    
    return _channel!.stream.map((event) {
      return jsonDecode(event) as Map<String, dynamic>;
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}