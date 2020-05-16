

import 'Mafia/Engine.dart';
import "Mafia/Structures/WinCondition.dart";

var townWinCon = new WinCondition(WinCondition.WHEN_X_FACTION_IS_DEAD, ["Mafia"]);
var mafWinCon = new WinCondition(WinCondition.WHEN_X_FACTION_IS_DEAD, ["Town"]);

void loadAllRoles(Engine game) {

    game.roles.add(
      name: "Citizen",
      faction: "Town",
      alignment: "Casual",
      winCondition: townWinCon
    );

    game.roles.add(
      name: "Goon",
      faction: "Mafia",
      alignment: "Casual",
      winCondition: mafWinCon
    );

}

void loadGameSettings(Engine game) {
   game.phases.addMany([
  {"name": "Day_1", "duration": 15000, "next": "Night"},
  {"name": "Day", "duration": 40000, "next": "Voting"},
  {"name": "Voting", "duration": 60000, "next": "Night"}, 
  {"name": "Defense", "duration": 20000, "next": "Judgement"}, 
  {"name": "Judgement", "duration": 40000, "next": "Last_Words"}, 
  {"name": "Last_Words", "duration": 5000, "next": "Night"}, 
  {"name": "Night", "duration": 60000, "next": "Day"},
]);

}