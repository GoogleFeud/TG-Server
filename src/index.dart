


import './Server/Server.dart';
import 'Mafia/Collection.dart';
import 'Mafia/Engine.dart';
import "./requests.dart";
import "./socketEvents.dart";

Collection<String, Engine> games = new Collection();


void main() async {
  Server server = new Server();
  server.public("./public");

  setRequests(server, games);
  setSocketEvents(server, games);

  server.listen(4000);
  
}

//dart --observe ./src/index.dart