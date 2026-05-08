import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  late WebSocketChannel _channel;

  // Gunakan link RESMI dari soal UTS
  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );
  }

  Stream<String> get priceStream {
    return _channel.stream.map((event) {
      // Data dari coincap biasanya bentuknya JSON: {"bitcoin":"65000.12"}
      final data = jsonDecode(event);
      return data['bitcoin'].toString(); 
    });
  }

  void disconnect() {
    _channel.sink.close();
  }
}