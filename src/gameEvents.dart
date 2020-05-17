

import "./Mafia/Engine.dart" show events, Engine;
import 'Server/Server.dart';

void setGameEvents(Server server) {
   
   events.on("setRole", (Engine engine, Map data) {
       if (data["previous"] == null) {
           data["player"].ws.send("start", {"role": data["current"].simplify(engine)});
       }
   });

   events.on("Day_1", (Engine engine, Map data) {
     engine.players.forEach((p) => p.ws.send("Day_1", data["phase"].simplify()));
   });

   events.on("win", (Engine engine, Map data) {
       engine.players.forEach((p) => p.ws.send("win", {"winners": engine.winConditioner.winners.map((w) => w.name).toList()}));
   });
}