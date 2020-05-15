

import 'Mafia/Engine.dart';
import "Mafia/Structures/WinCondition.dart";

var townWinCon = new WinCondition(WinCondition.WHEN_X_FACTION_IS_DEAD, ["Mafia"]);

void loadAllRoles(Engine game) {
    game.roles.add(
      name: "Citizen",
      faction: "Town",
      alignment: "Casual",
      winCondition: townWinCon
    );

}