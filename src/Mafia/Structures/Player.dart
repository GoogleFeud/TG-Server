

import '../../Server/WebSocket.dart';
import '../Collection.dart';
import '../Engine.dart';
import 'NightAction.dart';
import 'Role.dart';


class Player {
    Engine engine;
    CustomWebSocket ws;
    String name;
    int num;
    Player votedFor;
    int votes = 0;
    Role role;
    bool dead = false;
    NightAction action;
    Map tempStorage = {};
    Map permStorage = {"votingPower": 1};
    List<String> deathReasons = [];

    Player({Engine engine, String name, int number, CustomWebSocket ws}) {
       this.engine = engine;
       this.name = name;
       this.num = number;
       this.ws = ws;
    }

    Role setTheRole(Role role) {
        var prev = this.role;
        Future.delayed(Duration(milliseconds: 200), () => events.emit("setRole", this.engine, {"player": this, "previous": prev, "current": role}));
        this.role = role;
        return role;
    }

    NightAction setNightAction([Player target, Map data]) {
         NightAction a = new NightAction(this, target, data);
         this.action = a;
         if (data["factionalAction"] == true) this.engine.factionalActions[this.role.faction] = this;
         events.emit("setAction", this.engine, {"player": this, "action": a});
         return a;
    }

    void cancelNightAction() {
        if (this.action.others["factionalAction"] == true) this.engine.factionalActions.remove(this.role.faction);
        events.emit("cancelAction", this.engine, {"player": this, "action": this.action});
        this.action = null; 
    }

    vote(Player target) {
       target.votes += this.getFromStorage("votingPower");
       if (this.votedFor != null) {
         this.votedFor.votes -= this.getFromStorage("votingPower");
         var old = this.votedFor;
         if (target.votes >= this.engine.players.calculateMajority()) return events.emit("voteMaj", this.engine, {"voter": this, "votee": target});
         events.emit("switchVote", this.engine, {"voter": this, "votee": target, "previous": old});
       }else {
         this.votedFor = target;
         if (target.votes >= this.engine.players.calculateMajority()) return events.emit("voteMaj", this.engine, {"voter": this, "votee": target});
         events.emit("vote", this.engine, {"voter": this, "votee": target});
       }
    }

    unvote() {
      this.votedFor.votes -= this.getFromStorage("votingPower");
      events.emit("unvote", this.engine, {"voter": this, "votee": this.votedFor});
      this.votedFor = null;
    }

    kill([String reason]) {
       this.dead = true;
       this.engine.noDeathsIn = 0;
       if (reason != null) this.deathReasons.add(reason);
    }

    revive() {
      this.dead = false;
      this.engine.noDeathsIn = 0;
      this.deathReasons.clear();
    }

    setVotingPower(int power) {
      events.emit("setVotingPower", this.engine, {"player": this, "power": power});
      if (this.votedFor != null) {
         this.votedFor.votes -= this.getFromStorage("votingPower");
         this.votedFor.votes += power;
         if (this.votedFor.votes >= this.engine.players.calculateMajority()) return events.emit("voteMaj", this.engine, {"voter": this, "votee": this.votedFor});
      }
      this.permStorage["votingPower"] = power;
    }

    Collection<String, Player> voters() {
        return this.engine.players.filter((p) => p.votedFor.name == this.name);
    }

    Collection<String, Player> visitors() {
       return this.engine.players.filter((p) => p?.action?.target?.name == this.name && p.astral != true);
    }

    Collection<String, Player> realVisitors() {
       return this.engine.players.filter((p) => p?.action?.target?.name == this.name);
    }

    bool canKill(Player target) {
        if (target.role.attributes.get(Role.AUTO_VEST) && this.attack <= (target.defense + 1)) {
            target.role.attributes.clear(Role.AUTO_VEST);
            return false;
        }
        return this.attack > target.defense;
    }

    dynamic getFromStorage(String key) {
      if (this.tempStorage.containsKey(key)) return this.tempStorage[key];
      if (this.permStorage.containsKey(key)) return this.permStorage[key];
      return null;
    }

    int get priority {
      if (this.tempStorage.containsKey("priority")) return this.tempStorage["priority"];
      if (this.permStorage.containsKey("priority")) return this.permStorage["priority"];
      return this.role.priority;
    }

    int get attack {
       if (this.tempStorage.containsKey("attack")) return this.tempStorage["attack"];
       if (this.permStorage.containsKey("attack")) return this.permStorage["attack"];
       return this.role.attack;
    }

    int get defense {
       if (this.tempStorage.containsKey("defense")) return this.tempStorage["defense"];
       if (this.permStorage.containsKey("defense")) return this.permStorage["defense"];
       return this.role.defense;
    }

    bool get astral {
      if (this.tempStorage.containsKey("astral")) return this.tempStorage["astral"];
       if (this.permStorage.containsKey("astral")) return this.permStorage["astral"];
       return this.role.attributes.get(Role.ASTRAL);
    }

    String get displayRole {
      return (this.getFromStorage("cleaned") == true) ? "???":this.role.name;
    }

    Bitfield toBits([Player requestedPlayer]) {
      var field = new Bitfield();
      if (this.dead) field.update(0); // Is dead, pos: 0
      if (this.ws.host) field.update(1); // Is host: pos 1
      if (this.ws.admin) field.update(2); // Is admin, pos 2
      if (this.ws.state == CustomWebSocketStates.DISCONNECTED) field.update(3); // Is disconnected
   /*   if (this.role != null) {
        field.update(4, this.role.amountOfTargets); // Amount of targets
        field.update(5, this.role.amountOfTargets == 1 ? 1:0); // If 1 target
        field.update(6, this.role.amountOfTargets == 2 ? 1:0); // If 2 targets
        field.update(5, this.role.allowSelf); // If can target self
        field.update(6, this.role.canTargetDead); // If can target dead
        field.update(7, this.role.factionalAction); // Factional mafia
      }  */
      return field;
    }

    toString() {
      return this.name;
    }

    clear() {
       this.role = null;
       this.votes = 0;
       this.votedFor = null;
       this.action = null;
       this.dead = false;
       this.tempStorage = {};
       this.permStorage = {"votingPower": 1};
       this.deathReasons = [];
    }

    simplify([bool includeRole = true]) {
      return {
        "name": this.name,
        "id": this.ws.id,
        "details": this.toBits().bits,
        "role": (includeRole && this.role != null) ? this.role.simplify(this.engine):null,
        "v": (this.role != null) ? this.votes:null,
        "vFor": (this.votedFor != null) ? this.votedFor.simplify():null,
        "dead": this.dead
      };
    }

}

