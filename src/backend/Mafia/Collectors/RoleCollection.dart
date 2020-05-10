

import "../Structures/Role.dart" show  Role;
import "../Collection.dart" show Collection;

class RoleCollection extends Collection<String, Role> {
    RoleCollection() : super() {
    }

    Role add({String name, String faction, String alignment, int uses, int bits, List<String> cantTarget, int priority, int amount, Function action, dynamic winCondition}) {
        Role s = new Role(name: name, faction: faction, alignment: alignment, uses: uses, bits: bits, cantTarget: cantTarget, priority: priority, amount: amount, action: action, winCondition: winCondition);
        this.set(name, s);
        return s;
    }

    void reduce(String name) {
        this.get(name).amount--;
    }

    Role generate(String name) {
      return this.get(name).clone();
    }

    Role any([List<Role> alreadyRolled, Function rules]) {
       Role slot;
       if (rules != null && alreadyRolled != null) slot = this.random(filter: (r) => rules(r, alreadyRolled, "Any"))[0];
       else slot = this.random()[0];
       if (slot == null) return null;
       if (slot.amount != null) {
                if (slot.amount == 1) this.delete(slot.name);
       else slot.amount--;
       }
       return slot.clone(["Any"]);
    }

    Role fromFaction(String faction, [List<Role> alreadyRolled, Function rules]) {
      Role slot = this.random(filter: (v) => v.faction == faction && (rules == null || rules(v, alreadyRolled, "Random", faction)))[0];
      if (slot == null) return null;
      if (slot.amount != null) {
          if (slot.amount == 1) this.delete(slot.name);
       else slot.amount--;
       }
       return slot.clone(["Random", faction]);
    }

    Role fromAlignment(String faction, String alignment, [List<Role> alreadyRolled, Function rules]) {
       Role slot = this.random(filter: (v) => v.faction == faction && v.alignment == alignment && (rules == null || rules(v, alreadyRolled, faction, alignment)))[0];
       if (slot == null) return null;
       if (slot.amount != null) {
        if (slot.amount == 1) this.delete(slot.name);
        else slot.amount--;
       }
       return slot.clone([faction, alignment]);
    }

    Role fromName(String name) {
      Role slot = this.get(name);
       if (slot == null) return null;
       if (slot.amount != null) {
        if (slot.amount == 1) this.delete(slot.name);
       else slot.amount--;
       }
       return slot.clone([name]);
    }

    List<Role> rollRolelist(List<String> rolelist, [Function rules]) {
        List<Role> roles = [];
        for (String slot in rolelist) {
            List<String> dec = slot.split(" ");
            if (dec[0] == "Any") roles.add(this.any(roles, rules));
            else if (this.has(dec[0])) roles.add(this.fromName(dec[0]));
            else if (dec[0] == "Random") roles.add(this.fromFaction(dec[1], roles, rules));
            else roles.add(this.fromAlignment(dec[0], dec[1], roles, rules));
        }
        return roles;
    }



}