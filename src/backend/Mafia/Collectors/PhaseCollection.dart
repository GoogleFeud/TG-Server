

import 'dart:async';

import "../Collection.dart" show Collection;
import '../Engine.dart';
import '../Structures/Phase.dart';

class PhaseCollection extends Collection<String, Phase> {
     Engine engine;
     Phase current;
     DateTime phaseStartedAt;
     
     PhaseCollection(Engine engine):super() {
        this.engine = engine;
     }

     add(dynamic phaseLike) {
        var p;
        if (phaseLike is Map) p = new Phase(phaseLike["name"], phaseLike["duration"], phaseLike["next"], phaseLike["iterations"]);
        else p = phaseLike;
        this.set(p.name, p);
     }

     addMany(List<dynamic> phases) {
         for (var phase in phases) this.add(phase);
     }

     next([Phase customCurrent, int customDuration]) {

       this.engine.timer = new Timer(Duration(milliseconds: customDuration != null ? customDuration:this.current.duration), () {
           this.phaseStartedAt = DateTime.now();
           this.engine.noDeathsIn++;

           if (this.current != null) {
             events.emit("${this.current.name}-End", this.engine, {"phase": this.current});
             this.current.iterations++;
           } 

           // CHECK WIN HERE
            if (customCurrent != null) this.current = customCurrent;
            else this.current = this.get(this.current.next);
            events.emit(this.current.name, this.engine, {"phase": this.current});
            this.next();
       });
     }

    Phase jumpTo(String phaseName, [int specificMoment]) {
       this.engine.timer.cancel();
       Phase phase = this.get(phaseName);
       this.next(phase, specificMoment != null ? specificMoment:0);
       return phase;
    }


}