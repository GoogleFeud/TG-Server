
import "dart:io";
import 'src/Server.dart';
import "src/WebSocket.dart" show CustomWebSocket, subscribeToEvent;

Map sockets = new Map();

void home(HttpRequest request, Server server) {
   server.sendFile("./test.html", request);
}

void upgrade(HttpRequest request, Server server) async {
   CustomWebSocket ws = await server.createWebsocket(request);
   /**
    * (id) {
     return sockets[id];
   });
    */
   sockets[ws.id] = ws;
   ws.send(1, {"msg": "Hello!"});
}

void main() async {
  Server server = new Server();
  server.public("./public");
  server.add("/", "GET", home);
  server.add("/ws", "UPGRADE", upgrade);

  subscribeToEvent("msg", (CustomWebSocket s, data) => print("Socket ${s.id} said ${data["msg"]}"));

  subscribeToEvent("reconnect", (CustomWebSocket s, data) { // Reconnection after partial disconnection
    print("Socket ${s.id} reconnected!");
    s.cancelDisconnectTimer();
  });

  subscribeToEvent("disconnect", (CustomWebSocket s, data) { // Partial Disconnection
    print("Socket ${s.id} disconnected!");
    s.startDisconnectTimer(Duration(seconds: 10), server);
  });

  subscribeToEvent("remove", (CustomWebSocket s, data) { // Complete disconnection
    print("Socket ${s.id} completely disconnected! Byebye!");
    sockets.remove(s.id);
  });

  subscribeToEvent("duplicate", (CustomWebSocket s, data) { // When somebody tries to connect with the same IDs
    print("Socket ${s.id} is a duplicate!");
    sockets.remove(s.id);
  });

  server.listen(4000);
}
