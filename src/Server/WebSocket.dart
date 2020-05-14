

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
    static const KICKED = 3;
    static const CONNECTED = 2;
    static const TEMP_DISCONNECTED = 1;
    static const DISCONNECTED = 0;
}

class CustomWebSocket {
    String id;
    String name;
    String lobbyId;
    String ip;
    bool reconnected = false;
    bool host = false;
    bool admin = false;
    bool longRec = false;
    WebSocket socket;
    Timer disconnectTimer;
    int state = 2;

    String setId() {
        this.id = _rng_string(20);
        return this.id;
    }


     startDisconnectTimer(Duration dur, Server server) {
      if (this.state == CustomWebSocketStates.KICKED) return;
      this.disconnectTimer = new Timer(dur, () {
           server.doNotReconnect(this.id);
           callEvent("remove", this); // Update state in event
       });
    }

    void cancelDisconnectTimer() {
      this.disconnectTimer?.cancel();
    }

    void send(String event, dynamic data) {
        if (this.socket.readyState == WebSocket.closed) return;
        this.socket.add(json.encode({"e": event, "d": data}));
    }

    void swapSocket(WebSocket socket) {
      this.socket = socket;
    }

    void setPingInterval(int interval) {
       this.socket.pingInterval = Duration(milliseconds: interval);
    }

    void close(Server server) {
       this.state = CustomWebSocketStates.KICKED;
       this.socket.close();
       if (this.disconnectTimer != null) this.disconnectTimer.cancel();
       server.doNotReconnect(this.id);
       callEvent("remove", this);
    } 



}