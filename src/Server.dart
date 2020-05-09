
import 'dart:async';
import "dart:io";
import 'dart:convert' show json, utf8, base64;
import "WebSocket.dart" show CustomWebSocket, callEvent, CustomWebSocketStates;

 class Server {
  HttpServer engine;
  Map paths;
  Map reconnecting;

  Server() {
     this.paths = new Map();
     this.reconnecting = new Map();
  }

  void add(String path, String method, Function(HttpRequest, Server) res) {
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
         this.add(file.path.replaceFirst("$dirName\\", "/").replaceAll("\\", "/"), "GET", (HttpRequest req, Server ser) => ser.sendFile(file.path, req));
    }
  }

  void listen(int port, [Function wsFilter]) async {
      this.engine = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    port,
  );
  await for (var request in this.engine) {
       if (request.headers.value("Upgrade") == "websocket") this.paths["/ws"]["UPGRADE"](request, this);
       else if (this.paths[request.uri.path] == null) {
         request.response.statusCode = 404;
         request.response.close();
       }
       else if (this.paths[request.uri.path][request.method] != null) this.paths[request.uri.path][request.method](request, this);
  }
}

  Future<CustomWebSocket> createWebsocket(HttpRequest req, [Function existingSocketVerifier, bool ignoreDups]) async {
      CustomWebSocket customSocket;
      String socketId = this.getCookie("sid_c_d", req)?.value;
      if (existingSocketVerifier != null) {
        CustomWebSocket verified = existingSocketVerifier(socketId);
        if (verified != null) {
        if (verified.state == CustomWebSocketStates.TEMP_DISCONNECTED) {
           this.reconnecting.remove(verified.id);
           verified.state = CustomWebSocketStates.CONNECTED;
           verified.swapSocket(await WebSocketTransformer.upgrade(req));
           callEvent("reconnect", verified);
        }
        else if (verified.state == CustomWebSocketStates.CONNECTED) {
          callEvent("duplicate", verified);
          if (ignoreDups == false || ignoreDups == null) return verified;
          return null;
        }
        customSocket = verified;
        }
      }
      if (customSocket == null) {
       customSocket = this.reconnecting[socketId];
      if (socketId != null && customSocket != null) {
        this.reconnecting.remove(customSocket.id);
        customSocket.state = CustomWebSocketStates.CONNECTED;
        customSocket.swapSocket(await WebSocketTransformer.upgrade(req));
        callEvent("reconnect", customSocket);
      }else {
        customSocket = new CustomWebSocket();
        this.setCookie("sid_c_d", customSocket.setId(), req);
        customSocket.swapSocket(await WebSocketTransformer.upgrade(req));
      }
      }
      customSocket.socket.listen((data) {
         Map obj = json.decode(data);
         callEvent(obj["e"], customSocket, obj["d"]);
      }, onDone: () {
          customSocket.state = CustomWebSocketStates.TEMP_DISCONNECTED;
          callEvent("disconnect", customSocket);
          this.reconnecting[customSocket.id] = customSocket;
      });
      return Future.delayed(Duration(milliseconds: 500), () => customSocket.socket.readyState == WebSocket.open ? customSocket:null);
  }

  void doNotReconnect(String socket_id) {
    this.reconnecting.remove(socket_id);
  }

  void sendFile(String path, HttpRequest req) async {
     String type = "text/" + path.split(".")[2];
     if (Server.TRANSLATED_TYPES[type] != null) type = Server.TRANSLATED_TYPES[type];
     req.response.headers.set(HttpHeaders.contentTypeHeader, type);
     if (type.startsWith("image")) {
        List<int> buff = await new File(path).readAsBytes();
        req.response.headers.set('Content-Length', buff.length);
        req.response.add(buff);
     req.response.close();
     }else {
     String buff = await new File(path).readAsString();
     req.response.headers.set('Content-Length', buff.length);
     req.response.write(buff);
     }
     req.response.close();
  }

  void sendJSON(Map object, HttpRequest req) {
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

  static String toJSON(Map object) {
       return json.encode(object);
  }

  static Map fromJSON(String js) {
    return json.decode(js);
  } 


}