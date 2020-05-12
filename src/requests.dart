


import 'dart:io';
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import 'Server/Server.dart';
import 'Server/WebSocket.dart';

void setRequests(Server server, Collection<String, Lobby> lobbies, Collection<String, Engine> games) {

  server.add("/ws", "UPGRADE", (request) async {
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
    CustomWebSocket ws = await server.createWebsocket(request, (id, HttpRequest req) {
      return lob.players.where((w) => w.ip == req.connectionInfo.remoteAddress.address || w.name == req.requestedUri.queryParameters["name"]);
    });
    if (!ws.reconnected) {
    print("${ws.name} joined the lobby!");
    lob.players.add(ws);
    ws.host = toBeHost;
     ws.send("lobbyInfo", {
         "players": lob.players.map<Map>((s) => {"name": s.name, "admin": s.admin, "host": s.host}).toList(),
         "yourName": ws.name
       });
    }
  }else {
      CustomWebSocket ws = await server.createWebsocket(request);
      game.spectators.add(ws);
      // Alert all spectators, send game data...
  }
  });

  server.add("/api/playersIn", "GET", (HttpRequest req) {
        var gameId = req.requestedUri.queryParameters["roomId"];
        if (!lobbies.has(gameId)) server.sendJSON([], req);
        else {
        var game = lobbies.get(gameId);
        server.sendJSON(game.players.where((p) => p.ip == req.connectionInfo.remoteAddress.address ? p.state != CustomWebSocketStates.TEMP_DISCONNECTED:true).map((p) => p.name).toList(), req);
        }
  });

}