


import 'dart:io';
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import 'Server/Server.dart';

void setRequests(Server server, Collection<String, Lobby> lobbies, Collection<String, Engine> games) {

  server.add("/api/playersIn", "GET", (HttpRequest req) {
        var gameId = req.requestedUri.queryParameters["lobbyId"];;
        if (!lobbies.has(gameId)) {
            server.setStatusCode(404, req);
            return req.response.close();
        }
        var game = lobbies.get(gameId);
        server.sendJSON(game.connections.map((p) => p.name), req);
        return 0;
  });

}