
import 'dart:async';

import '../Server/WebSocket.dart';
import "./Collectors/PlayerCollection.dart";
import "./Collectors/RoleCollection.dart";
import "./Collectors/EventCollection.dart";
import 'Collection.dart';
import 'Collectors/PhaseCollection.dart';
import 'Structures/Player.dart';
import 'Structures/Role.dart';
import 'Structures/WinConditioner.dart';

EventCollection events = new EventCollection();


class Engine {
   PlayerCollection players;
   List<CustomWebSocket> spectators;
   RoleCollection roles = new RoleCollection();
   PhaseCollection phases;
   WinConditioner winConditioner = new WinConditioner();
   Map factionalActions = {};
   Timer timer;
   int noDeathsIn = 0;
   String id;

   Engine(String id) {
      this.id = id;
      this.players = new PlayerCollection(this);
      this.phases = new PhaseCollection(this);
   }

   bool roll(List<String> rolelist, [Function rules]) {
     List<Role> roles;
     try {
       roles = this.roles.rollRolelist(rolelist, rules);
     }catch(err) {
       return false;
     }
     if (this.players.size != roles.length) return false;
     roles.shuffle();
     Collection players = this.players.clone();
     for (Role role in roles) {
         Player rng = players.random()[0];
         rng.setTheRole(role);
         players.delete(rng.name);
     }
     return true;
   }

   void start() {
     this.phases.next(this.phases.first(), 0);
   }

   void stop() {
     this.players.clear();
     this.timer.cancel();
     this.noDeathsIn = 0;
  }

   List<int> timeLeft() {
       int now = DateTime.now().millisecondsSinceEpoch;
       int msLeft = this.phases.current.duration - (now - this.phases.phaseStartedAt.millisecondsSinceEpoch);
       int mins = (msLeft / 60000).floor();
       int secs = ((msLeft % 60000) / 1000).round();
        if (secs == 60) {
            mins++;
            secs = 0;
        }
        return [mins, secs];
   }

   bool checkWin() {
      var check = this.winConditioner.check(this);
      if (check != null) {
         events.emit("win", this, {"check": check});
         this.stop();
         return true;
      }
      return false;
   }

   static int addBits(List<int> bits) {
         int tot = 0;
         for (int bit in bits) tot ^= (1 << bit);
         return tot;
   }

}

class Lobby {
    String id;
    List<CustomWebSocket> connections = [];

    Lobby(String id) {
       this.id = id;
    }

    Engine expand() {
       Engine res = new Engine(this.id);
       for (var connection in this.connections) res.players.add(name: connection.name, ws: connection);
       this.connections.clear();
       return res;
    }

}