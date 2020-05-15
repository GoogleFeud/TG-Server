
import "./Server/WebSocket.dart" show CustomWebSocket, CustomWebSocketStates, subscribeToEvent;
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import 'Server/Server.dart';

void setSocketEvents(Server server, Collection<String, Engine> games) {


  subscribeToEvent("reconnect", (CustomWebSocket s, data) { // Reconnection after partial disconnection
    s.cancelDisconnectTimer();
    var game = games.get(s.lobbyId);
    if (game != null) {
    s.send("lobbyInfo", {
          "players": game.players.map<Map>((s) => {"name": s.name, "id": s.ws.id, "details": s.toBits().bits}),
          "yourName": s.name,
          "rl": game.rolelist.where((w) => w != null).toList()
          // Send other info if the game has started...
       });
    if (s.longRec) {
      game.players.forEach((p) => p.ws.send("playerReconnect", {"id": s.id}));
      s.longRec = false;
    }
    }
  });

  subscribeToEvent("disconnect", (CustomWebSocket s, data) { // Partial Disconnection
    Future.delayed(Duration(seconds: 5), () {
       if (s.state == CustomWebSocketStates.CONNECTED) return;
       s.longRec = true;
       games.get(s.lobbyId)?.players?.forEach((p) => p.ws.send("playerTempDisconnect", {"id": s.id}));
    });
    s.startDisconnectTimer(Duration(seconds: 10), server);
  });

  subscribeToEvent("remove", (CustomWebSocket s, data) { // Complete disconnection
    if (s.state == CustomWebSocketStates.DISCONNECTED) return;
    if (games.has(s.lobbyId)) {
     var lob = games.get(s.lobbyId);
     if (lob.timer == null && lob.rolelist.length > 0) {
     lob.rolelist[lob.players.size - 1] = null;
     lob.players.remove(s.id);
     if (lob.players.size == 0) games.delete(s.lobbyId);
     else {
            if (s.host) lob.players.first().ws.host = true;
            lob.players.forEach((v) => v.ws.send("playerLeave", {"id": s.id}));
     }
     }
   }
   s.state = CustomWebSocketStates.DISCONNECTED;
  });

  subscribeToEvent("duplicate", (CustomWebSocket s, data) { // When somebody tries to connect with the same IDs
    Engine room = games.get(data["newSocket"].lobbyId);
    if (room == null) return;
    room.players.forEach((p) => p.ws.send("message", {"content": "${data["newSocket"].name} is an alt of ${data["allDups"].map((w) => w.name).join(", ")}", "sender": "system"}));
  });

  subscribeToEvent("message", (CustomWebSocket s, data) {
    Engine room = games.get(s.lobbyId) ?? games.get(s.lobbyId);
    if (room == null) return;
    room.players.forEach((p) => p.ws.send("message", data));
  });

}