
import "./src/backend/Mafia/Engine.dart";

/** 
import "dart:io";
import 'src/backend/Server/Server.dart';
import "src/backend/Server/WebSocket.dart" show CustomWebSocket, subscribeToEvent;

Map sockets = new Map();

void home(HttpRequest request, Server server) {
   server.sendFile("./test.html", request);
}

void upgrade(HttpRequest request, Server server) async {
   CustomWebSocket ws = await server.createWebsocket(request);
   /**
    * (id) {
     return sockets[id];
   });
    */
   sockets[ws.id] = ws;
   ws.send(1, {"msg": "Hello!"});
}

void main() async {
  Server server = new Server();
  server.public("./public");
  server.add("/", "GET", home);
  server.add("/ws", "UPGRADE", upgrade);

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
    sockets.remove(s.id);
  });

  subscribeToEvent("duplicate", (CustomWebSocket s, data) { // When somebody tries to connect with the same IDs
    print("Socket ${s.id} is a duplicate!");
    sockets.remove(s.id);
  });

  server.listen(4000);
}
**/

void main() {

events.on("setRole", (Engine engine, Map data) {
   print("${data["player"].name}'s role is now ${data["current"].name}");
});

events.on("Day", (Engine engine, Map data) {
   var phase = data["phase"];
   print("It's Day ${phase.iterations}");
   if (phase.iterations == 4) {
      engine.phases.jumpTo("Secret");
   }
});

events.on("Night", (Engine engine, Map data) {
   var phase = data["phase"];
   print("It's Night ${phase.iterations}");
});

events.on("Secret", (Engine engine, Map data) {
   print("Secret :D");
});

Engine game = new Engine();

game.roles.add(
   name: "Citizen",
   faction: "Town",
   alignment: "Citizen",
  );

  game.roles.add(
   name: "Jailor",
   faction: "Town",
   amount: 1,
   alignment: "Citizen"
  );

  game.roles.add(
   name: "Goon",
   faction: "Mafia",
   alignment: "Citizen"
  );

  game.roles.add(
   name: "Mafioso",
   faction: "Mafia",
   amount: 1,
   alignment: "Killing"
  );

game.players.create(name: "Google");
game.players.create(name: "Volen");
game.players.create(name: "Tyler");

game.phases.addMany([
  {"name": "Day", "duration": 10000, "next": "Night"},
  {"name": "Night", "duration": 5000, "next": "Day"},
  {"name": "Secret", "duration": 15000, "next": "Night"}
]);

game.roll([
  "Any",
  "Random Town",
  "Random Mafia"
], (currentRole, [rolledRoles, slot1, slot2]) {
      if (currentRole.name == "Citizen" && slot1 == "Any") return false;
      return true;
});

print(game.players.map((p) => p.role.name));
game.start();

}