

import '../../Server/WebSocket.dart';
import "../Collection.dart" show Collection;
import '../Engine.dart';
import '../Structures/Player.dart';

class PlayerCollection extends Collection<String, Player> {
  Engine engine;
   
    PlayerCollection(engine):super()  {
      this.engine = engine;
    }

    Player create({String name, CustomWebSocket ws}) {
         Player pl = new Player(engine: this.engine, number: this.size + 1, name: name, ws: ws);
         this.set(name, pl);
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
      List<Player> s = this.values().where((v) => v.role != null && v.role.priority > 0 && v.getFromStorage("roleblocked") == null).toList();
      s.sort((p, p1) => p.priority - p1.priority);
      return s;
    }



}