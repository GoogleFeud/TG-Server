


import 'dart:io';
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import 'Server/Server.dart';
import 'Server/WebSocket.dart';
import "./roles.dart";

void setRequests(Server server, Collection<String, Engine> games) {

  server.add("/ws", "UPGRADE", (request) async {
     if (!request.requestedUri.queryParameters.containsKey("roomId") || !request.requestedUri.queryParameters.containsKey("name")) return;
     String roomId = request.requestedUri.queryParameters["roomId"];
     if (roomId.length > 6) {
         server.setStatusCode(400, request);
         return request.response.close();
     };
    var game = games.get(roomId);
    if (game == null) {
      game = games.set(roomId, new Engine(roomId));
      loadAllRoles(game);
    }
    CustomWebSocket ws = await server.createWebsocket(request, (id, HttpRequest req) {
      return game.players.filter((w) => w.ws.id == id || w.name == req.requestedUri.queryParameters["name"] || w.ws.ip == req.connectionInfo.remoteAddress.address).map<CustomWebSocket>((w) => w.ws);
    });
    if (ws.name == "a" || game.players.size == 15) {
    ws.send("kick", {});
    ws.close(server);
    return;
    }
    if (!ws.reconnected && game.timer == null) {
    if (game.players.size > 0) game.players.forEach((p) => p.ws.send("playerJoin", {"name": ws.name, "id": ws.id}));
    game.rolelist[game.players.size] = "Any";
    game.players.add(name: ws.name, ws: ws);
    if (game.players.size == 1) ws.host = true;
    ws.send("lobbyInfo", {
          "players": game.players.map<Map>((s) => {"name": s.name, "id": s.ws.id, "details": s.toBits().bits}),
          "yourName": ws.name,
          "rl": game.rolelist.where((w) => w != null).toList()
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
       //server.sendJSON(game.players.map((p) => p.name).toList(), req);
        }
  });

  server.add("/api/pwd", "GET", (HttpRequest req) {
    var game = games.get(req.requestedUri.queryParameters["lobbyId"]);
    if (game == null || !game.players.has(req.requestedUri.queryParameters["player"])) return server.sendJSON({"res": false}, req);
     if ("12345" == req.requestedUri.queryParameters["password"]) {
       game.players.get(req.requestedUri.queryParameters["player"]).ws.admin = true;
       game.players.forEach((p) => p.ws.send("admin", {"id": req.requestedUri.queryParameters["player"]}));
       return server.sendJSON({"res": true}, req);
     }
     server.sendJSON({"res": false}, req);
  });

  
  server.add("/api/kick", "GET", (HttpRequest req) {
    var game = games.get(req.requestedUri.queryParameters["lobbyId"]);
    var kickee = game.players.figureOutPlayer(req.requestedUri.queryParameters["player"]);
    if (game == null || kickee == null) return server.sendJSON({"res": false}, req);
    var kicker = game.players.get(req.requestedUri.queryParameters["kicker"]);
    if (kicker == null || !kicker.ws.admin) return server.sendJSON({"res": false}, req);
    kickee.ws.send("kick", {});
    kickee.ws.close(server);
    server.sendJSON({"res": true}, req);
  });

  server.add("/api/changerl", "GET", (HttpRequest req) {
     var game = games.get(req.requestedUri.queryParameters["lobbyId"]);
     var setter = game?.players?.get(req.requestedUri.queryParameters["setter"]);
     if (game == null || setter == null) return server.sendJSON({"res": false}, req);
     if (!setter.ws.admin && !setter.ws.host) return server.sendJSON({"res": false}, req);
     if (!game.roles.testSlot(req.requestedUri.queryParameters["content"])) return server.sendJSON({"res": false}, req);
     try {
       game.rolelist[int.parse(req.requestedUri.queryParameters["index"])] = req.requestedUri.queryParameters["content"];
     }catch(err) {
        return server.sendJSON({"res": false}, req);
     }
     server.sendJSON({"res": true}, req);
     game.players.forEach((p) => p.ws.send("rolelistChange", {"index": req.requestedUri.queryParameters["index"], "content": req.requestedUri.queryParameters["content"], "changedBy": setter.name } ));
  });

  server.add("/api/whisper", "GET", (HttpRequest req) {
    var game = games.get(req.requestedUri.queryParameters["lobbyId"]);
    if (game == null) return server.sendJSON({"res": false}, req);
    var whisperer = game.players.get(req.requestedUri.queryParameters["whisperer"]);
    var target = game.players.figureOutPlayer(req.requestedUri.queryParameters["receiver"]);
    if (whisperer == null || target == null || whisperer.dead || target.dead) server.sendJSON({"res": false}, req);
    game.players.forEach((p) => p.ws.send("message", {"content": req.requestedUri.queryParameters["msg"], "sender": whisperer.name, "receiver": target.name, "whisper": true}));
  });

  server.add("/api/start", "GET", (HttpRequest req) {
      var game = games.get(req.requestedUri.queryParameters["lobbyId"]);
      if (game == null || !game.players.has(req.requestedUri.queryParameters["starter"])) return server.sendJSON({"res": false}, req);
      if (game.roll(game.rolelist.where((w) => w != null).toList()) == false) return server.sendJSON({"res": false}, req);
      game.start();
  });

}