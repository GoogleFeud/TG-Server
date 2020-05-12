
import 'dart:async';
import "dart:io";
import 'dart:convert' show json;
import "WebSocket.dart" show CustomWebSocket, callEvent, CustomWebSocketStates;

 class Server {
  HttpServer engine;
  Map paths = {};
  Map reconnecting = {};


  void add(String path, String method, Function res) {
   if (this.paths.containsKey(path)) this.paths[path][method] = res;
    else {
      this.paths[path] = new Map();
      this.paths[path][method] = res;
    }
  }

  void public(String dirName) {
    Directory dir = new Directory(dirName);
    for (var file in dir.listSync(recursive: true, followLinks: false) ) {
         file = new File(file.path);
         this.add(file.path.replaceFirst("$dirName\\", "/").replaceAll("\\", "/"), "GET", (HttpRequest req) => this.sendFile(file.path, req));
    }
  }

  void listen(int port, [Function wsFilter]) async {
      this.engine = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    port,
  );
  await for (var request in this.engine) {
       if (request.headers.value("Upgrade") == "websocket") this.paths["/ws"]["UPGRADE"](request);
       else if (this.paths[request.requestedUri.path] == null) {
           this.sendFile("./index.html", request);
       }
       else if (this.paths[request.requestedUri.path][request.method] != null) this.paths[request.requestedUri.path][request.method](request);
  }
}

Future<CustomWebSocket> createWebsocket(HttpRequest req, [Function existingSocketVerifier]) async {
      CustomWebSocket customSocket;
      String socketId = req.requestedUri.queryParameters["socketId"];
      if (socketId == null || socketId.length != 18) return null;
      if (existingSocketVerifier != null) {
        List<CustomWebSocket> AllVerified = existingSocketVerifier(socketId, req);
        if (AllVerified.length > 0) {
        CustomWebSocket verified = AllVerified.firstWhere((element) => element.id == socketId, orElse: () => null);
        if (verified != null && verified.state == CustomWebSocketStates.TEMP_DISCONNECTED) {
           this.reconnecting.remove(verified.id);
           verified.state = CustomWebSocketStates.CONNECTED;
           verified.reconnected = true;
           verified.swapSocket(await WebSocketTransformer.upgrade(req));
           callEvent("reconnect", verified);
           customSocket = verified;
        }
        else if (verified == null) {
            customSocket = new CustomWebSocket();
            customSocket.id = socketId;
            customSocket.swapSocket(await WebSocketTransformer.upgrade(req));
            customSocket.name = req.requestedUri.queryParameters["name"];
            customSocket.lobbyId = req.requestedUri.queryParameters["roomId"];
            callEvent("duplicate", verified, {"allDups": AllVerified, "newSocket": customSocket});
        }
        }
      }
      if (customSocket == null) {
       customSocket = this.reconnecting[socketId];
      if (socketId != null && customSocket != null) {
        this.reconnecting.remove(customSocket.id);
        customSocket.state = CustomWebSocketStates.CONNECTED;
        customSocket.reconnected = true;
        customSocket.swapSocket(await WebSocketTransformer.upgrade(req));
        callEvent("reconnect", customSocket);
      }else {
        customSocket = new CustomWebSocket();
        customSocket.id = socketId;
        customSocket.swapSocket(await WebSocketTransformer.upgrade(req));
      }
      }
      if (!customSocket.reconnected) {
      customSocket.ip = req.connectionInfo.remoteAddress.address;
      customSocket.name = req.requestedUri.queryParameters["name"];
      customSocket.lobbyId = req.requestedUri.queryParameters["roomId"];
      }
      customSocket.socket.listen((data) {
        try {
          dynamic obj = json.decode(data); 
          callEvent(obj["e"], customSocket, obj["d"]);
        }catch(err) {
           customSocket.socket.close(400);
        }
      }, onDone: () {
          customSocket.state = CustomWebSocketStates.TEMP_DISCONNECTED;
          callEvent("disconnect", customSocket);
          this.reconnecting[customSocket.id] = customSocket;
      });
      return Future.delayed(Duration(milliseconds: 300), () => customSocket.socket.readyState == WebSocket.open ? customSocket:null);
  }


  void doNotReconnect(String socket_id) {
    this.reconnecting.remove(socket_id);
  }

   sendFile(String path, HttpRequest req) async {
     String type = "text/" + path.split(".")[2];
     if (Server.TRANSLATED_TYPES[type] != null) type = Server.TRANSLATED_TYPES[type];
     req.response.headers.set(HttpHeaders.contentTypeHeader, type);
     if (type.startsWith("image")) {
        List<int> buff = await new File(path).readAsBytes();
        req.response.headers.set('Content-Length', buff.length);
        req.response.add(buff);
     req.response.close();
     }else {
     File buff = await new File(path);
     req.response.headers.set('Content-Length', await buff.length());
     await req.response.addStream(buff.openRead());
     }
     req.response.close();
  }

  void sendJSON(dynamic object, HttpRequest req) {
      req.response.write(json.encode(object));
      req.response.close();
  }

  void sendText(String text, HttpRequest req) {
    req.response.write(text);
    req.response.close();
  }

  void setStatusCode(int code, HttpRequest req) {
      req.response.statusCode = code;
  }

  void setCookie(String key, String value, HttpRequest req, [Map options]) {
      Cookie cookie = new Cookie(key, value);
      if (options != null && options.containsKey("httpOnly")) cookie.httpOnly = options["httpOnly"]; 
      if (options != null && options.containsKey("expires")) cookie.httpOnly = options["expires"]; 
      if (options != null && options.containsKey("secure")) cookie.httpOnly = options["secure"]; 
      req.response.cookies.add(new Cookie(key, value));
  }

  void deleteCookie(String key, HttpRequest req) {
      req.response.cookies.removeWhere((k) => k.name == key);
  }

  Cookie getCookie(String key, HttpRequest req) {
    return req.cookies.firstWhere((e) => e.name == key, orElse: () => null);
  }

  static final Map TRANSLATED_TYPES = {
     "text/js": "text/javascript",
     "text/png": "image/png",
     "text/jpg": "image/jpg"
  };

  static String toJSON(dynamic object) {
       return json.encode(object);
  }

  static Map fromJSON(String js) {
    return json.decode(js);
  } 


}

