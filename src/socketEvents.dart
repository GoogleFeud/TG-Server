
import "./Server/WebSocket.dart" show CustomWebSocket, subscribeToEvent;
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import 'Server/Server.dart';

void setSocketEvents(Server server, Collection<String, Lobby> lobbies, Collection<String, Engine> games) {


  subscribeToEvent("reconnect", (CustomWebSocket s, data) { // Reconnection after partial disconnection
    print("Socket ${s.id} reconnected!");
    s.cancelDisconnectTimer();
    if (lobbies.has(s.lobbyId)) {
       var lob = lobbies.get(s.lobbyId);
       s.send("lobbyInfo", {
          "players": lob.players.map<Map>((s) => {"name": s.name, "admin": s.admin, "host": s.host}).toList(),
          "yourName": s.name
       });
    } // Check for game
  });

  subscribeToEvent("disconnect", (CustomWebSocket s, data) { // Partial Disconnection
    print("Socket ${s.id} disconnected!");
    s.startDisconnectTimer(Duration(seconds: 20), server);
  });

  subscribeToEvent("remove", (CustomWebSocket s, data) { // Complete disconnection
    print("Socket ${s.id} completely disconnected! Byebye!");
    if (lobbies.has(s.lobbyId)) {
     var lob = lobbies.get(s.lobbyId);
     lob.players.remove(s);
     if (lob.players.length == 0) lobbies.delete(lob.id);
    }else if (games.has(s.lobbyId)) {
       var game = games.get(s.lobbyId);
       events.emit("disconnect", game, {"socket": s});
    }
  });

  subscribeToEvent("duplicate", (CustomWebSocket s, data) { // When somebody tries to connect with the same IDs
    Lobby room = lobbies.get(data["newSocket"].lobbyId) ?? games.get(data["newSocket"].lobbyId);
    if (room == null) return;
    room.players.forEach((dynamic p) => p.id != null ? p.send("message", {"content": "${data["newSocket"].name} is an alt of ${data["allDups"].map((w) => w.name)}", "sender": "system"}):p.ws.send("message", {"content": "${data["newSocket"].name} is an alt of ${data["allDups"].map((w) => w.name)}", "sender": "system"}));
  });

  subscribeToEvent("message", (CustomWebSocket s, data) {
    Lobby room = lobbies.get(s.lobbyId) ?? games.get(s.lobbyId);
    if (room == null) return;
    room.players.forEach((dynamic p) => p.id != null ? p.send("message", data):p.ws.send("message", data));
  });

}