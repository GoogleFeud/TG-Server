
import "./src/backend/Mafia/Engine.dart";
import 'src/backend/Mafia/Structures/Role.dart';

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
   Future.delayed(Duration(seconds: 4), () {
     engine.players.forEach((p) => p.vote(engine.players.random()[0]));
   });
   if (phase.iterations == 4) {
      engine.phases.jumpTo("Secret");
   }
});

events.on("Day-End", (Engine engine, Map data) {
    engine.players.clearRelatedProperties();
});

events.on("Night", (Engine engine, Map data) {
   var phase = data["phase"];
   print("It's Night ${phase.iterations}");
   engine.players.find((p) => p.role.name == "Goon")?.setNightAction(engine.players.find((p) => p.role.name == "Jailor"));
});

events.on("setAction", (Engine engine, Map data)  {
     var p = data["player"];
     print("${p} set their action! Their target is ${p.action.target}");
});

events.on("Night-End", (Engine engine, Map data) {
   var phase = data["phase"];
   engine.players.executeNightActions();
   print("Night ${phase.iterations} is over!");
});

events.on("vote", (Engine engine, Map data) {
     var voter = data["voter"];
     var votee = data["votee"];
     print("${voter} has voted for ${votee}. ${votee} now has ${votee.votes} votes.");
});

events.on("voteMaj", (Engine engine, Map data) {
   var voter = data["voter"];
    var votee = data["votee"];
    print("${voter} has voted for ${votee}. ${votee} now has ${votee.votes} votes, that's the majority! Say bye to ${votee}!");
    votee.kill();
    engine.phases.jumpTo("Night");
});

events.on("Secret", (Engine engine, Map data) {
   print("Secret :D");
});

Engine game = new Engine();


  game.roles.add(
   name: "Jailor",
   faction: "Town",
   amount: 1,
   priority: 5,
   alignment: "Power",
   bits: Engine.addBits([Role.AUTO_VEST]),
   action: (player, [target, Map data]) {
       print("${player} (with role ${player.role}) did their night action}");
   }
  );

  game.roles.add(
   name: "Goon",
   faction: "Mafia",
   priority: 4,
   attack: 1,
   alignment: "Citizen",
   action: (player, [target, Map data]) {
       if (player.canKill(target)) {
          target.kill("murdered by the Mafia");
          print("${player} murdered ${target}!");
       }else print("${player} coudn't kill ${target}");
   }
  );

  game.roles.add(
   name: "Mafioso",
   faction: "Mafia",
   amount: 1,
   priority: 3,
      action: (player, [target, Map data]) {
       print("${player} (with role ${player.role}) did their night action on ${target}");
   },
   alignment: "Killing"
  );

game.players.add(name: "Google");
game.players.add(name: "Volen");
game.players.add(name: "Tyler");

game.phases.addMany([
  {"name": "Day", "duration": 10000, "next": "Night"},
  {"name": "Night", "duration": 5000, "next": "Day"},
  {"name": "Secret", "duration": 15000, "next": "Night"}
]);

game.roll([
  "Random Town",
  "Random Mafia",
   "Any"
]);

print(game.players.map((p) => p?.role?.name));
game.start();

}