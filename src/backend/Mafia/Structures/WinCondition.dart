

class WinCondition {
    int condition = 0;
    List<String> targets = []; //Factions + Roles
    List<String> ignores = []; //Factions + Roles
    List<String> mustDie = []; //Factions + Roles

    WinCondition(int condition, [List<String> targets, List<String> ignores, List<String> mustDie]) {
      this.condition = condition;
      if (targets != null) this.targets = targets;
      if (ignores != null) this.ignores = ignores;
      if (mustDie != null) this.mustDie = mustDie;
    }

    static WinCondition from(dynamic thing) {
       if (thing is WinCondition) return thing;
       else if (thing is int) return new WinCondition(thing);
       return null;
    }

    static const int ONLY_ROLE_IN_GAME = 1;
    static const int ONLY_FACTION_IN_GAME = 2;
    static const int WHEN_THIS_FACTION_MORE_THAN_X_FACTION = 3;
    static const int WHEN_X_FACTION_IS_DEAD = 4;
    static const int WHEN_X_ROLE_DIES = 5;
    static const int WHEN_X_PLAYER_DIES = 6;
}