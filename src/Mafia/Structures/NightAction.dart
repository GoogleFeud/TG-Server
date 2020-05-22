

import 'Player.dart';

class NightAction {
    Player player;
    Player target;
    bool activated = false;
    Map others = {};

    NightAction(Player player, [Player target, Map others]) {
      this.player = player;
      if (target != null) this.target = target;
      if (others != null) this.others = others; 
    }

    void clear() {
       this.target = null;
       this.others.clear();
       this.activated = false;
    }

    void setFactionalAction(bool r) {
       this.others["factionalAction"] = r;
    }

    simplify() {
      return {
        "target": this.target?.ws?.id,
        "other": this.others
      };
    }


    bool get factionalAction {
        return this.others["factionalAction"];
    }

    
}