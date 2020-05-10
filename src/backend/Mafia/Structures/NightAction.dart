

import 'Player.dart';

class NightAction {
    Player player;
    Player target;
    Map others = {};

    Action(Player player, [Player target, Map others]) {
      this.player = player;
      if (target != null) this.target = target;
      if (others != null) this.others = others; 
    }

    

    bool get factionalAction {
        return this.others["factionalAction"];
    }

    
}