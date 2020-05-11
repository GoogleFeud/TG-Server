

class WinCondition {
    int condition = 0;
    List<String> targets = []; //Factions + Roles
    List<String> mustDie = []; //Factions + Roles
    List<String> ignore = [];

    WinCondition(int condition, [List<String> targets, List<String> mustDie, List<String> ignore]) {
      this.condition = condition;
      if (targets != null) this.targets = targets;
      if (mustDie != null) this.mustDie = mustDie;
      if (ignore != null) this.ignore = ignore;
    }

    operator ==(dynamic other) {
      if (other is int) return this.condition == other;
      if (other is WinCondition) return this.condition == other.condition;
      return false;
    }

    static const int ONLY_ROLE_IN_GAME = 1;
    static const int ONLY_FACTION_IN_GAME = 2;
    static const int WHEN_THIS_FACTION_MORE_THAN_X_FACTION = 3;
    static const int WHEN_X_FACTION_IS_DEAD = 4;
    static const int WHEN_X_FACTION_IS_DEAD_NOEND = 5;

    static const List<int> FACTION_RELATED_CONDITIONS = [2, 3, 4];
}