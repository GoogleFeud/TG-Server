
const Socket = new WebSocket("ws://localhost:4000");

Socket.onopen = () => {
    console.log("Socket opened!");

    Socket.onmessage = (msg) => {
        console.log(msg);
        Socket.send(JSON.stringify({e: "msg", d: {msg: "Test!"}}));
        setTimeout(() => Socket.send(JSON.stringify({e: "msg", d: {msg: "TestAAAA!"}})), 4000);
    }
}