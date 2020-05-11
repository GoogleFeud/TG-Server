


import "dart:io";
import './Server/Server.dart';
import "./Server/WebSocket.dart" show CustomWebSocket, subscribeToEvent;
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';

Collection<String, Lobby> lobbies = new Collection();
Collection<String, Engine> games = new Collection();

void home(HttpRequest request, Server server) {
   server.sendFile("./test.html", request);
}

void main() async {
  Server server = new Server();
  server.public("./public");
  server.add("/", "GET", (request, server) {
    server.sendFile("./test.html", request);
  });

  server.add("/ws", "UPGRADE", (request, server) async {
     String roomId = request.requestedUri.queryParameters["roomId"];
     if (roomId == null || roomId.length > 6) {
         server.setStatusCode(400, request);
         return request.response.close();
     };
    bool toBeHost = false;
    if (!lobbies.has(roomId)) {
      toBeHost = true;
      lobbies.set(roomId, new Lobby(roomId));
    }
    Lobby lob = lobbies.get(roomId);
    CustomWebSocket ws = await server.createWebsocket(request, (id) {
      return lob.connections.firstWhere((w) => w.id == id, orElse: () => null);
   }, true);
    lob.connections.add(ws);
    ws.lobbyId = roomId;
    ws.host = toBeHost;
    ws.ip = request.connectionInfo.remoteAddress.address;
  });

  subscribeToEvent("msg", (CustomWebSocket s, data) => print("Socket ${s.id} said ${data["msg"]}"));

  subscribeToEvent("reconnect", (CustomWebSocket s, data) { // Reconnection after partial disconnection
    print("Socket ${s.id} reconnected!");
    s.cancelDisconnectTimer();
  });

  subscribeToEvent("disconnect", (CustomWebSocket s, data) { // Partial Disconnection
    print("Socket ${s.id} disconnected!");
    s.startDisconnectTimer(Duration(seconds: 10), server);
  });

  subscribeToEvent("remove", (CustomWebSocket s, data) { // Complete disconnection
    print("Socket ${s.id} completely disconnected! Byebye!");
    if (lobbies.has(s.lobbyId)) {
     var lob = lobbies.get(s.lobbyId);
     lob.connections.remove(s);
     if (lob.connections.length == 0) lobbies.delete(lob.id);
    }
  });

  subscribeToEvent("duplicate", (CustomWebSocket s, data) { // When somebody tries to connect with the same IDs
    var room = lobbies.get(s.lobbyId);
    print("Socket ${data["newSocket"].id} is a duplicate of ${room.connections.where((w) => w.ip == s.ip).map((w) => w.id)}!");
  });

  server.listen(4000);
  
}

//dart --observe ./src/backend/index.dart