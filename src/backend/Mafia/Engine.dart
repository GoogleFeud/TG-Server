
import 'dart:async';

import "./Collectors/PlayerCollection.dart";
import "./Collectors/RoleCollection.dart";
import "./Collectors/EventCollection.dart";
import 'Collection.dart';
import 'Collectors/PhaseCollection.dart';
import 'Structures/Player.dart';
import 'Structures/Role.dart';

EventCollection events = new EventCollection();


class Engine {
   PlayerCollection players;
   RoleCollection roles = new RoleCollection();
   PhaseCollection phases;
   Timer timer;
   int noDeathsIn = 0;

   Engine() {
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


}