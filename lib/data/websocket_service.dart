import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  late WebSocketChannel _channel;

  void connect() {
    // LINK RESMI DARI DOSEN (Wajib WSS, bukan HTTP/HTTPS)
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );
  }

  Stream<String> get priceStream {
    return _channel.stream.map((event) {
      try {
        final data = jsonDecode(event);
        if (data != null && data.containsKey('bitcoin')) {
          return data['bitcoin'].toString();
        }
        return "MENUNGGU";
      } catch (e) {
        return "MENUNGGU";
      }
    });
  }

  void disconnect() {
    _channel.sink.close();
  }
}