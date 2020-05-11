
import "./src/Mafia/Engine.dart";
import 'src//Mafia/Structures/Role.dart';
import 'src/Mafia/Structures/WinCondition.dart';


void main() {

events.on("setRole", (Engine engine, [Map data]) {
   print("${data["player"].name}'s role is a ${data["current"].name}");
});

events.on("Day", (Engine engine, [Map data]) {
   var phase = data["phase"];
   print("It's Day ${phase.iterations}");
   if (phase.iterations == 1) {
        Future.delayed(Duration(seconds: 4), () {
     engine.players.forEach((p) => p.vote(engine.players.random()[0]));
   });
   }
   else if (phase.iterations == 4) {
      engine.phases.jumpTo("Secret");
   }
});

events.on("Day-End", (Engine engine, [Map data]) {
    engine.players.clearRelatedProperties();
});

events.on("Night", (Engine engine, [Map data]) {
   var phase = data["phase"];
   print("It's Night ${phase.iterations}");
   engine.players.alive().forEach((p) {
     p.setNightAction(engine.players.random(filter: (pl) => !pl.dead && pl.name != p.name)[0]);
   });
});

events.on("setAction", (Engine engine, [Map data])  {
     var p = data["player"];
     print("${p} set their action! Their target is ${p.action.target}");
});

events.on("Night-End", (Engine engine, [Map data]) {
   var phase = data["phase"];
   engine.players.executeNightActions();
   print("Night ${phase.iterations} is over!");
});

events.on("vote", (Engine engine, [Map data]) {
     var voter = data["voter"];
     var votee = data["votee"];
     print("${voter} has voted for ${votee}. ${votee} now has ${votee.votes} votes.");
});

events.on("voteMaj", (Engine engine, [Map data]) {
   var voter = data["voter"];
    var votee = data["votee"];
    print("${voter} has voted for ${votee}. ${votee} now has ${votee.votes} votes, that's the majority! Say bye to ${votee}!");
    votee.kill();
    engine.phases.jumpTo("Night");
});

events.on("win", (Engine engine, [Map data]) {
   print("${data["check"]} wins! Winners: ${engine.winConditioner.stripWinners()}");
});

Engine game = new Engine("1");

WinCondition townWin = new WinCondition(WinCondition.WHEN_X_FACTION_IS_DEAD, ["Mafia"], ["Neutral_Killing"]);
WinCondition mafWin = new WinCondition(WinCondition.WHEN_X_FACTION_IS_DEAD, ["Town"], ["Neutral_Killing"]);
WinCondition neutWin = new WinCondition(WinCondition.ONLY_ROLE_IN_GAME, null, null, ["Neutral_Evil", "Neutral_Benign"]);
WinCondition evilWin = new WinCondition(WinCondition.WHEN_X_FACTION_IS_DEAD_NOEND, ["Town"]);

  game.roles.add(
   name: "Jailor",
   faction: "Town",
   amount: 1,
   attack: 1,
   priority: 5,
   winCondition: townWin,
   alignment: "Power",
   bits: Engine.addBits([Role.AUTO_VEST]),
   action: (player, [target, Map data]) {
        if (player.canKill(target)) {
          target.kill("murdered by the Town");
          print("${player} murdered ${target}!");
       }else print("${player} coudn't kill ${target}");
   }
  );

  game.roles.add(
   name: "Goon",
   faction: "Mafia",
   priority: 4,
   attack: 1,
   winCondition: mafWin,
   alignment: "Citizen",
   action: (player, [target, Map data]) {
       if (player.canKill(target)) {
          target.kill("murdered by the Mafia");
          print("${player} murdered ${target}!");
       }else print("${player} coudn't kill ${target}");
   }
  );

/** game.roles.add(
   name: "Mafioso",
   faction: "Mafia",
   amount: 1,
   winCondition: mafWin,
   priority: 3,
      action: (player, [target, Map data]) {
       print("${player} (with role ${player.role}) did their night action on ${target}");
   },
   alignment: "Killing"
  ); **/

  game.roles.add(
   name: "Butcher",
   faction: "Neutral",
   winCondition: neutWin,
   priority: 5,
   attack: 1,
   defense: 1,
   action: (player, [target, Map data]) {
        if (player.canKill(target)) {
          target.kill("murdered by the Butcher");
          print("${player} murdered ${target}!");
       }else print("${player} coudn't kill ${target}");
   },
   alignment: "Killing"
  );

  
  game.roles.add(
   name: "Witch",
   faction: "Neutral",
   winCondition: evilWin,
   alignment: "Evil"
  );

game.players.add(name: "Google");
game.players.add(name: "Volen");
game.players.add(name: "Tyler");

game.phases.addMany([
  {"name": "Day", "duration": 10000, "next": "Night"},
  {"name": "Night", "duration": 5000, "next": "Day"},
  {"name": "Secret", "duration": 15000, "next": "Night"}
]);

// HOW TG's would look like: (example)

/**
 * game.phases.addMany([
  {"name": "Day_1", "duration": 15000, "next": "Night"},
  {"name": "Day", "duration": 40000, "next": "Voting"},
  {"name": "Voting", "duration": 60000, "next": "Night"}, --> This can go to two directions, Defense if a player has reached enough votes and Night if they don't
  {"name": "Defense", "duration": 20000, "next": "Judgement"}, --> Player can say something, only that player
  {"name": "Judgement", "duration": 40000, "next": "Last_Words"}, --> Players vote either "guilty", "innocent" or "abstain" ---> innocent goes to Night, guilty goes to last words
  {"name": "Last_Words", "duration": 5000, "next": "Night"}, --> The player says their last words..
  {"name": "Night", "duration": 60000, "next": "Day"},
]);
 */

game.roll([
  "Witch",
  "Neutral Killing",
  "Random Mafia"
]);

game.start();

}