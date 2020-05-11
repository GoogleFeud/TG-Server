

import '../Engine.dart';
import 'Player.dart';
import 'WinCondition.dart';

class WinConditioner {
    List<Player> winners = [];

    Set<Player> stripWinners() {
      this.winners.removeWhere((w) => w.dead && !WinCondition.FACTION_RELATED_CONDITIONS.contains(w.role.winCondition.condition));
      return this.winners.toSet();
    }
    
    dynamic check(Engine engine) {
       List<Player> players = engine.players.filter((p) => !p.dead && p.role.winCondition.condition != 0).values();
       if (players.length == 0) return "draw";
       Map<String, bool> cache = {};
       String toBeReturned;
       for (Player player in players) {
         if (cache[player.role.name] == true) continue;
         if (cache[player.role.faction] == true) continue;

         if (player.role.winCondition == WinCondition.ONLY_FACTION_IN_GAME) {
           cache[player.role.faction] = true;
           var allP = players.where((p) => !player.role.winCondition.ignore.contains(p.role.faction) || !player.role.winCondition.ignore.contains(p.role.realName) || !player.role.winCondition.ignore.contains(p.role.faction + "_" + p.role.alignment));
           var allOfF = players.where((p) => p.role.faction == player.role.faction);
           if (allOfF.length == allP.length) {
             this.winners.addAll(allOfF);
             toBeReturned = player.role.faction;
           }
         }
         else if (player.role.winCondition == WinCondition.ONLY_ROLE_IN_GAME) {
           cache[player.role.realName] = true;
           var allP = players.where((p) => player.role.winCondition.ignore.contains(p.role.faction) == false && player.role.winCondition.ignore.contains(p.role.realName) == false && player.role.winCondition.ignore.contains(p.role.faction + "_" + p.role.alignment) == false);
           var allOfF = players.where((p) => p.role.realName == player.role.realName);
           if (allOfF.length == allP.length) {
             this.winners.addAll(allOfF);
             toBeReturned = player.role.name;
           }
         }
         else if (player.role.winCondition == WinCondition.WHEN_THIS_FACTION_MORE_THAN_X_FACTION) {
           cache[player.role.faction] = true;
           if (player.role.winCondition.mustDie.length > 0 && players.any((p) => player.role.winCondition.mustDie.contains(p.role.faction) || player.role.winCondition.mustDie.contains(p.role.realName) || player.role.winCondition.mustDie.contains(p.role.faction + "_" + p.role.alignment))) continue;
           var thisFac = players.where((p) => p.role.faction == player.role.faction);
           var xFac = players.where((p) => p.role.faction == player.role.winCondition.targets[0]);
           if (thisFac.length > xFac.length) {
              this.winners.addAll(thisFac);
              toBeReturned = player.role.faction;
           }
        }
        else if (player.role.winCondition == WinCondition.WHEN_X_FACTION_IS_DEAD) {
          cache[player.role.faction] = true;
          if (player.role.winCondition.mustDie.length > 0 && players.any((p) => player.role.winCondition.mustDie.contains(p.role.faction) || player.role.winCondition.mustDie.contains(p.role.realName) || player.role.winCondition.mustDie.contains(p.role.faction + "_" + p.role.alignment))) continue;
          var xFac = players.where((p) => p.role.faction == player.role.winCondition.targets[0]);
          if (xFac.length == 0) {
              this.winners.addAll(players.where((p) => p.role.faction == player.role.faction));
              toBeReturned = player.role.faction;
          }
        }
        else if (player.role.winCondition == WinCondition.WHEN_X_FACTION_IS_DEAD_NOEND) {
            cache[player.role.name] = true;
            if (player.role.winCondition.mustDie.length > 0 && players.any((p) => player.role.winCondition.mustDie.contains(p.role.faction) || player.role.winCondition.mustDie.contains(p.role.realName) || player.role.winCondition.mustDie.contains(p.role.faction + "_" + p.role.alignment))) continue;
            if (players.where((p) => p.role.faction == player.role.winCondition.targets[0]).length == 0) this.winners.addAll(players.where((p) => p.role.name == player.role.name));
            else this.winners.removeWhere((p) => p.role.name == player.role.name);
        }
       }
       return toBeReturned;
    }

}