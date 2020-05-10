
import "../Collection.dart" show Bitfield;
import 'WinCondition.dart';


class Role {
   String realName;
   String faction;
   String alignment;
   int uses;
   int amount;
   int priority;
   List<String> rolledFrom = [];
   List<String> cantTarget = new List<String>();
   Bitfield attributes = new Bitfield();
   WinCondition winCondition;
   Function action;

   Role({String name, String faction, String alignment, int uses, int bits, List<String> cantTarget, int priority, int amount, List<String> rolledFrom, Function action, dynamic winCondition}) {
      if (name != null) this.realName = name;
      if (faction != null) this.faction = faction;
      if (alignment != null) this.alignment = alignment;
      this.amount = amount;
      this.uses = uses;
      this.priority = priority ?? 5;
      this.action = action;
      this.rolledFrom = rolledFrom;
      this.winCondition = WinCondition.from(winCondition);
      if (bits != null) this.attributes.set(bits);
      if (cantTarget != null) this.cantTarget = cantTarget;
   }

   String get name {
     return this.realName.replaceAll("_", " ");
   }

   Role clone([List<String> rolledFrom]) {
     return new Role(name: this.realName, faction: this.faction, alignment: this.alignment, uses: this.uses, bits: this.attributes.bits, cantTarget: this.cantTarget, priority: this.priority, rolledFrom: rolledFrom, action: this.action);
   }

}