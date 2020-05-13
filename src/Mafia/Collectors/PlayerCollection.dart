

import '../../Server/WebSocket.dart';
import "../Collection.dart" show Collection;
import '../Engine.dart';
import '../Structures/Player.dart';
import '../Structures/Role.dart';

class PlayerCollection extends Collection<String, Player> {
  Engine engine;
   
    PlayerCollection(engine):super()  {
      this.engine = engine;
    }

    Player add({String name, CustomWebSocket ws}) {
         Player pl = new Player(engine: this.engine, number: this.size + 1, name: name, ws: ws);
         this.set(ws.id, pl);
         return pl;
    }

    Player remove(String name) {
       if (!this.has(name)) return null;
       Player p = this.get(name);
       this.forEach((v) {
         if (v.num > p.num) v.num--;
       });
       this.delete(name);
       return p;
    }

     calculateMajority() {
      int alive = this.alive().size;
      return (alive % 2 == 0) ? (alive / 2) + 1:(alive/2).ceil();
    }

    Collection<String, Player> alive() {
      return this.filter((v) => !v.dead);
    }

    Collection<String, Player> dead() {
        return this.filter((v) => v.dead);
    }

    Collection<String, Player> fromFaction(String fac) {
      return this.filter((v) => v.role.faction == fac);
    }

    Collection<String, Player> fromAlignment(String alignment, [String faction]) {
      return this.filter((v) => v.role.alignment == alignment && (faction == null || v.role.faction == faction));
    }

    List<Player> orderByPriority() {
      List<Player> s = this.filter((v) => v.role.attributes.get(Role.ALWAYS_ACTION) || (v.action != null && v.role != null && v.role.action != null && v.role.priority > 0 && v.getFromStorage("roleblocked") != true)).values();
      s.sort((p, p1) => p.priority - p1.priority);
      return s;
    }

    void executeNightActions() {
       List<Player> priorities = this.orderByPriority();
       for (Player p in priorities) {
           if (p.getFromStorage("roleblocked") == true) continue;
           p.role.action(p, p.action?.target, p.action?.others);
       }
    }

    void clearRelatedProperties() {
        this.forEach((p) {
            p.action = null;
            p.votes = 0;
            p.votedFor = null;
            p.tempStorage.clear();
        });
        this.engine.factionalActions.clear();
    }



}