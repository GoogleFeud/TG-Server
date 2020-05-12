


import 'dart:io';
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import 'Server/Server.dart';
import 'Server/WebSocket.dart';

void setRequests(Server server, Collection<String, Engine> games) {

  server.add("/ws", "UPGRADE", (request) async {
     if (!request.requestedUri.queryParameters.containsKey("roomId") || !request.requestedUri.queryParameters.containsKey("name")) return;
     String roomId = request.requestedUri.queryParameters["roomId"];
     if (roomId.length > 6) {
         server.setStatusCode(400, request);
         return request.response.close();
     };
    var game = games.get(roomId);
    if (game == null) game = games.set(roomId, new Engine(roomId));
    CustomWebSocket ws = await server.createWebsocket(request, (id, HttpRequest req) {
      return game.players.filter((w) => w.ws.ip == req.connectionInfo.remoteAddress.address || w.name == req.requestedUri.queryParameters["name"]).map<CustomWebSocket>((w) => w.ws);
    });
    if (ws == null) return;
    if (!ws.reconnected && game.timer == null) {
    if (game.players.size > 0) game.players.forEach((p) => p.ws.send("playerJoin", {"name": ws.name}));
    game.players.add(name: ws.name, ws: ws);
    if (game.players.size == 1) ws.host = true;
    ws.send("lobbyInfo", {
          "players": game.players.map<Map>((s) => {"name": s.name, "host": s.ws.host, "admin": s.ws.admin, "disconnected": s.ws.state == CustomWebSocketStates.TEMP_DISCONNECTED}),
          "yourName": ws.name
          // Send other info if the game has started...
       });
    }else if (game.timer != null) {
            CustomWebSocket ws = await server.createWebsocket(request);
            game.spectators.add(ws);
            // Alert all spectators, send game data...
    }
  });

  server.add("/api/playersIn", "GET", (HttpRequest req) {
        var gameId = req.requestedUri.queryParameters["roomId"];
        if (!games.has(gameId)) server.sendJSON([], req);
        else {
        var game = games.get(gameId);
        server.sendJSON(game.players.filter((p) => p.ws.ip == req.connectionInfo.remoteAddress.address ? p.ws.state != CustomWebSocketStates.TEMP_DISCONNECTED:true).map((p) => p.name).toList(), req);
        }
  });

  server.add("/api/pwd", "GET", (HttpRequest req) {
    var game = games.get(req.requestedUri.queryParameters["lobbyId"]);
    if (game == null || !game.players.has(req.requestedUri.queryParameters["player"])) return server.sendJSON({"res": false}, req);
     if ("12345" == req.requestedUri.queryParameters["password"]) {
       game.players.get(req.requestedUri.queryParameters["player"]).ws.admin = true;
       game.players.forEach((p) => p.ws.send("admin", {"name": req.requestedUri.queryParameters["player"]}));
       return server.sendJSON({"res": true}, req);
     }
     server.sendJSON({"res": false}, req);
  });

}