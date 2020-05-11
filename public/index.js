const ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

try {
const names = ["Volen", "Hidden","BS", "Zoro", "Mum"];
if (!sessionStorage.getItem("_sid_")) sessionStorage.setItem("_sid_", genid());
const Socket = new WebSocket(`ws://localhost:4000?roomId=123&name=${names[Math.floor(Math.random() * names.length)]}&socketId=${sessionStorage.getItem("_sid_")}`);

Socket.onopen = () => {
    console.log("Socket opened!");

    Socket.onmessage = (msg) => {
        console.log(msg);
        Socket.send(JSON.stringify({e: "msg", d: {msg: "Test!"}}));
        setTimeout(() => Socket.send(JSON.stringify({e: "msg", d: {msg: "TestAAAA!"}})), 4000);
    }

    Socket.onerror = (err) => {
        console.log(err);
    }
}
}catch(err) {
    console.log(err);
    console.log("OOP!");
}


function genid(ID_LENGTH = 18) {
  let rtn = '';
  for (let i = 0; i < ID_LENGTH; i++) {
    rtn += ALPHABET.charAt(Math.floor(Math.random() * ALPHABET.length));
  }
  return rtn;
}