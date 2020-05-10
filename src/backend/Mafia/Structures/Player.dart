

import '../../Server/WebSocket.dart';
import '../Engine.dart';
import 'NightAction.dart';
import 'Role.dart';


class Player {
    Engine engine;
    CustomWebSocket ws;
    String name;
    int num;
    Player votedFor;
    int votes;
    Role role;
    bool dead = false;
    NightAction action;
    Map tempStorage = {};
    Map permStorage = {"votingPower": 1};

    Player({Engine engine, String name, int number, CustomWebSocket ws}) {
       this.engine = engine;
       this.name = name;
       this.num = number;
       this.ws = ws;
    }

    Role setTheRole(Role role) {
        events.emit("setRole", this.engine, {"player": this, "previous": this.role, "current": role});
        this.role = role;
        return role;
    }


    dynamic getFromStorage(String key) {
      if (this.tempStorage.containsKey(key)) return this.tempStorage[key];
      if (this.permStorage.containsKey(key)) return this.permStorage[key];
      return 1;
    }

    int get priority {
      if (this.tempStorage.containsKey("priority")) return this.tempStorage["priority"];
      if (this.permStorage.containsKey("priority")) return this.permStorage["priority"];
      return this.role.priority;
    }

}

