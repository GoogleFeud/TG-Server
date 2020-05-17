

import '../Engine.dart';

class Phase {
    int duration; // in MS
    int iterations;
    String next;
    String name;

    Phase(String name, int duration, String next, [int iterations]) {
      this.iterations = iterations ?? 1;
      this.name = name;
      this.duration = duration;
      this.next = next;
    }

    toString() {
      return this.name;
    }

    simplify([Engine engine]) {
      return {
         "name": this.name,
         "iters": this.iterations,
         "dur": (engine != null) ?  (this.duration - (DateTime.now().millisecondsSinceEpoch - engine.phases.phaseStartedAt.millisecondsSinceEpoch)).round():this.duration,
      };
    }
    
}