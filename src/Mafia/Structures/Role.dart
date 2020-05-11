
import "../Collection.dart" show Bitfield;
import 'WinCondition.dart';


class Role {
   String realName;
   String name;
   String faction;
   String alignment;
   int uses;
   int amount;
   int priority;
   int attack;
   int defense;
   int amountOfTargets; // 0, 1 or 2
   int allowSelf; //0, 1 or 2
   int canTargetDead; // 0, 1 or 2
   int factionalAction; // 0, 1 or 2
   List<String> rolledFrom = [];
   List<String> cantTarget = new List<String>();
   Bitfield attributes = new Bitfield();
   WinCondition winCondition;
   Function action;

   Role({String name, String faction, String alignment, int uses, int bits, List<String> cantTarget, int priority, int amount, List<String> rolledFrom, Function action, WinCondition winCondition, int attack, int defense, int amountOfTargets, int allowSelf, int canTargetDead, int factionalAction}) {
      if (name != null) this.realName = name;
      if (faction != null) this.faction = faction;
      if (alignment != null) this.alignment = alignment;
      this.amount = amount;
      this.uses = uses;
      this.name = this.realName.replaceAll("_", " ");
      this.priority = priority ?? 5;
      this.action = action;
      this.rolledFrom = rolledFrom;
      this.attack = attack ?? 0;
      this.defense = defense ?? 0;
      this.amountOfTargets = amountOfTargets ?? 0;
      this.allowSelf = allowSelf ?? 0;
      this.canTargetDead = canTargetDead ?? 0;
      this.factionalAction = factionalAction ?? 0;
      this.winCondition = winCondition;
      if (bits != null) this.attributes.set(bits);
      if (cantTarget != null) this.cantTarget = cantTarget;
   }

   Role clone([List<String> rolledFrom]) {
     return new Role(name: this.realName, faction: this.faction, alignment: this.alignment, uses: this.uses, bits: this.attributes.bits, cantTarget: this.cantTarget, priority: this.priority, rolledFrom: rolledFrom, action: this.action, attack: this.attack, defense: this.defense, amountOfTargets: this.amountOfTargets, allowSelf: this.allowSelf, canTargetDead: this.canTargetDead, factionalAction: this.factionalAction, winCondition: this.winCondition);
   }

   toString() {
     return this.name;
   }

   static const int ALWAYS_ACTION = 0; // Tested
   static const int EVEN_NIGHTS_ONLY = 1; 
   static const int ODD_NIGHTS_ONLY = 2; 
   static const int AUTO_VEST = 3; // Implemented, not tested
   static const int ASTRAL = 4; // Implemented, not tested
   static const int ONE_SELF_VISIT = 5; 
   static const int DAY_ACTION = 6; 
   static const int EVEN_WHEN_DEAD = 7; 
}