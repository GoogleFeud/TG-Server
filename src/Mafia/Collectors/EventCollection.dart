
import '../Engine.dart';

class EventCollection {
     Map<String, Function> events = {};

      void on(String eventName, Function cb) {
        this.events[eventName] = cb;
      } 

      Function emit(String eventName, Engine engine, [Map data]) {
         if (!this.events.containsKey(eventName)) return null;
         return this.events[eventName](engine, data);
      }
    
}
