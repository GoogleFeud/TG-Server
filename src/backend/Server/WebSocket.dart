

import 'dart:async';
import 'dart:io';
import "dart:math" show Random;
import 'dart:convert' show json;

import 'Server.dart';

const String _valid_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

String _rng_string(int length) {
    String res = "";
    Random fac = new Random();
    for (int i=0; i < length; i++) {
        int num = fac.nextInt(length);
        res += _valid_chars.substring(num, num + 1);
    }
    return res;
}

Map _PACKETS = {};

void subscribeToEvent(String packetName, Function cb) {
   _PACKETS[packetName] = cb;
}

dynamic callEvent(String packetName, CustomWebSocket s, [Map data]) {
   if (_PACKETS.containsKey(packetName)) return _PACKETS[packetName](s, data);
}

class CustomWebSocketStates {
    static const CONNECTED = 2;
    static const TEMP_DISCONNECTED = 1;
    static const DISCONNECTED = 0;
}

class CustomWebSocket {
    String id;
    String name;
    String lobbyId;
    String ip;
    bool host;
    WebSocket socket;
    Timer disconnectTimer;
    int state = 2;

    String setId() {
        this.id = _rng_string(20);
        return this.id;
    }

    Timer startDisconnectTimer(Duration dur, Server server) {
       return this.disconnectTimer = new Timer(dur, () {
           server.doNotReconnect(this.id);
           this.state = CustomWebSocketStates.DISCONNECTED;
           callEvent("remove", this);
       });
    }

    void cancelDisconnectTimer() {
      this.disconnectTimer?.cancel();
    }

    void send(String event, Map data) {
        this.socket.add(json.encode({"e": event, "data": data}));
    }

    void swapSocket(WebSocket socket) {
      this.socket = socket;
    }

    void setPingInterval(int interval) {
       this.socket.pingInterval = Duration(milliseconds: interval);
    }


}