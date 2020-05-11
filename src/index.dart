


import "dart:io";
import './Server/Server.dart';
import "./Server/WebSocket.dart" show CustomWebSocket, subscribeToEvent;
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import "./requests.dart";

Collection<String, Lobby> lobbies = new Collection();
Collection<String, Engine> games = new Collection();

void home(HttpRequest request, Server server) {
   server.sendFile("./test.html", request);
}

void main() async {
  Server server = new Server();
  server.public("./public");
  server.add("/", "GET", (request, [server]) {
    server.sendFile("./test.html", request);
  });

  server.add("/ws", "UPGRADE", (request, [server]) async {
     if (!request.requestedUri.queryParameters.containsKey("roomId") || !request.requestedUri.queryParameters.containsKey("name")) return;
     String roomId = request.requestedUri.queryParameters["roomId"];
     if (roomId.length > 6) {
         server.setStatusCode(400, request);
         return request.response.close();
     };
    var game = games.get(roomId);
    if (game == null) {
    bool toBeHost = false;
    if (!lobbies.has(roomId)) {
      toBeHost = true;
      lobbies.set(roomId, new Lobby(roomId));
    }
    Lobby lob = lobbies.get(roomId);
    CustomWebSocket ws = await server.createWebsocket(request, (id, req) {
      return lob.connections.where((w) => w.ip == req.connectionInfo.remoteAddress.address);
    });
    if (!ws.reconnected) {
    print("A new player joined the lobby!");
    lob.connections.add(ws);
    ws.lobbyId = roomId;
    ws.host = toBeHost;
    ws.name = request.requestedUri.queryParameters["name"];
    ws.send("auth", {"a": 1});
    }
  }else {
      CustomWebSocket ws = await server.createWebsocket(request);
      game.spectators.add(ws);
      // Alert all spectators, send game data...
  }
  });

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
    }else if (games.has(s.lobbyId)) {
       var game = games.get(s.lobbyId);
       events.emit("disconnect", game, {"socket": s});
    }
  });

  subscribeToEvent("duplicate", (CustomWebSocket s, data) { // When somebody tries to connect with the same IDs
    print("Socket ${data["newSocket"].name} is a duplicate of ${data["allDups"].map((w) => w.name)}!");
  });

  setRequests(server, lobbies, games);

  server.listen(4000);
  
}

//dart --observe ./src/index.dart