!function e(t,r,a){function n(o,i){if(!r[o]){if(!t[o]){var l="function"==typeof require&&require;if(!i&&l)return l(o,!0);if(s)return s(o,!0);var p=new Error("Cannot find module '"+o+"'");throw p.code="MODULE_NOT_FOUND",p}var c=r[o]={exports:{}};t[o][0].call(c.exports,(function(e){return n(t[o][1][e]||e)}),c,c.exports,e,t,r,a)}return r[o].exports}for(var s="function"==typeof require&&require,o=0;o<a.length;o++)n(a[o]);return n}({1:[function(e,t,r){var a=function(e){"use strict";var t=Object.prototype,r=t.hasOwnProperty,a="function"==typeof Symbol?Symbol:{},n=a.iterator||"@@iterator",s=a.asyncIterator||"@@asyncIterator",o=a.toStringTag||"@@toStringTag";function i(e,t,r,a){var n=t&&t.prototype instanceof c?t:c,s=Object.create(n.prototype),o=new R(a||[]);return s._invoke=function(e,t,r){var a="suspendedStart";return function(n,s){if("executing"===a)throw new Error("Generator is already running");if("completed"===a){if("throw"===n)throw s;return x()}for(r.method=n,r.arg=s;;){var o=r.delegate;if(o){var i=w(o,r);if(i){if(i===p)continue;return i}}if("next"===r.method)r.sent=r._sent=r.arg;else if("throw"===r.method){if("suspendedStart"===a)throw a="completed",r.arg;r.dispatchException(r.arg)}else"return"===r.method&&r.abrupt("return",r.arg);a="executing";var c=l(e,t,r);if("normal"===c.type){if(a=r.done?"completed":"suspendedYield",c.arg===p)continue;return{value:c.arg,done:r.done}}"throw"===c.type&&(a="completed",r.method="throw",r.arg=c.arg)}}}(e,r,o),s}function l(e,t,r){try{return{type:"normal",arg:e.call(t,r)}}catch(e){return{type:"throw",arg:e}}}e.wrap=i;var p={};function c(){}function u(){}function d(){}var h={};h[n]=function(){return this};var f=Object.getPrototypeOf,y=f&&f(f(_([])));y&&y!==t&&r.call(y,n)&&(h=y);var m=d.prototype=c.prototype=Object.create(h);function g(e){["next","throw","return"].forEach((function(t){e[t]=function(e){return this._invoke(t,e)}}))}function v(e,t){var a;this._invoke=function(n,s){function o(){return new t((function(a,o){!function a(n,s,o,i){var p=l(e[n],e,s);if("throw"!==p.type){var c=p.arg,u=c.value;return u&&"object"==typeof u&&r.call(u,"__await")?t.resolve(u.__await).then((function(e){a("next",e,o,i)}),(function(e){a("throw",e,o,i)})):t.resolve(u).then((function(e){c.value=e,o(c)}),(function(e){return a("throw",e,o,i)}))}i(p.arg)}(n,s,a,o)}))}return a=a?a.then(o,o):o()}}function w(e,t){var r=e.iterator[t.method];if(void 0===r){if(t.delegate=null,"throw"===t.method){if(e.iterator.return&&(t.method="return",t.arg=void 0,w(e,t),"throw"===t.method))return p;t.method="throw",t.arg=new TypeError("The iterator does not provide a 'throw' method")}return p}var a=l(r,e.iterator,t.arg);if("throw"===a.type)return t.method="throw",t.arg=a.arg,t.delegate=null,p;var n=a.arg;return n?n.done?(t[e.resultName]=n.value,t.next=e.nextLoc,"return"!==t.method&&(t.method="next",t.arg=void 0),t.delegate=null,p):n:(t.method="throw",t.arg=new TypeError("iterator result is not an object"),t.delegate=null,p)}function b(e){var t={tryLoc:e[0]};1 in e&&(t.catchLoc=e[1]),2 in e&&(t.finallyLoc=e[2],t.afterLoc=e[3]),this.tryEntries.push(t)}function E(e){var t=e.completion||{};t.type="normal",delete t.arg,e.completion=t}function R(e){this.tryEntries=[{tryLoc:"root"}],e.forEach(b,this),this.reset(!0)}function _(e){if(e){var t=e[n];if(t)return t.call(e);if("function"==typeof e.next)return e;if(!isNaN(e.length)){var a=-1,s=function t(){for(;++a<e.length;)if(r.call(e,a))return t.value=e[a],t.done=!1,t;return t.value=void 0,t.done=!0,t};return s.next=s}}return{next:x}}function x(){return{value:void 0,done:!0}}return u.prototype=m.constructor=d,d.constructor=u,d[o]=u.displayName="GeneratorFunction",e.isGeneratorFunction=function(e){var t="function"==typeof e&&e.constructor;return!!t&&(t===u||"GeneratorFunction"===(t.displayName||t.name))},e.mark=function(e){return Object.setPrototypeOf?Object.setPrototypeOf(e,d):(e.__proto__=d,o in e||(e[o]="GeneratorFunction")),e.prototype=Object.create(m),e},e.awrap=function(e){return{__await:e}},g(v.prototype),v.prototype[s]=function(){return this},e.AsyncIterator=v,e.async=function(t,r,a,n,s){void 0===s&&(s=Promise);var o=new v(i(t,r,a,n),s);return e.isGeneratorFunction(r)?o:o.next().then((function(e){return e.done?e.value:o.next()}))},g(m),m[o]="Generator",m[n]=function(){return this},m.toString=function(){return"[object Generator]"},e.keys=function(e){var t=[];for(var r in e)t.push(r);return t.reverse(),function r(){for(;t.length;){var a=t.pop();if(a in e)return r.value=a,r.done=!1,r}return r.done=!0,r}},e.values=_,R.prototype={constructor:R,reset:function(e){if(this.prev=0,this.next=0,this.sent=this._sent=void 0,this.done=!1,this.delegate=null,this.method="next",this.arg=void 0,this.tryEntries.forEach(E),!e)for(var t in this)"t"===t.charAt(0)&&r.call(this,t)&&!isNaN(+t.slice(1))&&(this[t]=void 0)},stop:function(){this.done=!0;var e=this.tryEntries[0].completion;if("throw"===e.type)throw e.arg;return this.rval},dispatchException:function(e){if(this.done)throw e;var t=this;function a(r,a){return o.type="throw",o.arg=e,t.next=r,a&&(t.method="next",t.arg=void 0),!!a}for(var n=this.tryEntries.length-1;n>=0;--n){var s=this.tryEntries[n],o=s.completion;if("root"===s.tryLoc)return a("end");if(s.tryLoc<=this.prev){var i=r.call(s,"catchLoc"),l=r.call(s,"finallyLoc");if(i&&l){if(this.prev<s.catchLoc)return a(s.catchLoc,!0);if(this.prev<s.finallyLoc)return a(s.finallyLoc)}else if(i){if(this.prev<s.catchLoc)return a(s.catchLoc,!0)}else{if(!l)throw new Error("try statement without catch or finally");if(this.prev<s.finallyLoc)return a(s.finallyLoc)}}}},abrupt:function(e,t){for(var a=this.tryEntries.length-1;a>=0;--a){var n=this.tryEntries[a];if(n.tryLoc<=this.prev&&r.call(n,"finallyLoc")&&this.prev<n.finallyLoc){var s=n;break}}s&&("break"===e||"continue"===e)&&s.tryLoc<=t&&t<=s.finallyLoc&&(s=null);var o=s?s.completion:{};return o.type=e,o.arg=t,s?(this.method="next",this.next=s.finallyLoc,p):this.complete(o)},complete:function(e,t){if("throw"===e.type)throw e.arg;return"break"===e.type||"continue"===e.type?this.next=e.arg:"return"===e.type?(this.rval=this.arg=e.arg,this.method="return",this.next="end"):"normal"===e.type&&t&&(this.next=t),p},finish:function(e){for(var t=this.tryEntries.length-1;t>=0;--t){var r=this.tryEntries[t];if(r.finallyLoc===e)return this.complete(r.completion,r.afterLoc),E(r),p}},catch:function(e){for(var t=this.tryEntries.length-1;t>=0;--t){var r=this.tryEntries[t];if(r.tryLoc===e){var a=r.completion;if("throw"===a.type){var n=a.arg;E(r)}return n}}throw new Error("illegal catch attempt")},delegateYield:function(e,t,r){return this.delegate={iterator:_(e),resultName:t,nextLoc:r},"next"===this.method&&(this.arg=void 0),p}},e}("object"==typeof t?t.exports:{});try{regeneratorRuntime=a}catch(e){Function("r","regeneratorRuntime = r")(a)}},{}],2:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});var a,n=e("../Other/Commands"),s=(a=n)&&a.__esModule?a:{default:a};class o extends React.Component{constructor(e){super(e),this.messageList=React.createRef(),e.app.addMessage=e=>{this.addMessage(e)}}componentDidMount(){this.props.app.player.on("message",e=>{this.addMessage(e)})}render(){return React.createElement("div",null,React.createElement("div",{className:"play-messageList",ref:this.messageList}),React.createElement("input",{type:"text",className:"play-messageBox",onKeyUp:e=>{if(""!==e.target.value&&" "!==e.target.value&&(e.persist(),13===e.keyCode)){if(s.default.cmds.some(t=>e.target.value.startsWith(t)))return s.default.run(e.target.value,this.props.app),void(e.target.value="");e.persist(),this.props.app.player.send("message",{content:e.target.value.replace(/<\/?[^>]+(>|$)/g,""),sender:this.props.app.player.name}),e.target.value=""}}}))}addMessage(e){let t=e.content;console.log(e),t="system"===e.sender?`<span style="font-weight: bold; color: red">${e.content}</span>`:e.whisper?e.receiver===this.props.app.player.name?`<span style="font-weight: bold; color: green">Whisper from ${e.sender}: ${e.content}</span>:`:e.sender===this.props.app.player.name?`<span style="font-weight: bold; color: green">Whisper to ${e.receiver}:  ${e.content}</span>`:`<span style="font-weight: bold">${e.sender} is whispering to ${e.receiver}</span>`:`<span style="font-weight: bold">${e.sender}</span>: ${e.content}`;const r=document.createElement("p");r.innerHTML=t,this.messageList.current.appendChild(r),r.scrollIntoView()}}r.default=o},{"../Other/Commands":9}],3:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});class a extends React.Component{constructor(e){super(e),this.state={players:[]}}render(){return React.createElement("div",{className:"play-graveyardBox"})}}r.default=a},{}],4:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});class a extends React.Component{constructor(e){super(e)}render(){let e="black";return console.log(this.props.details,this.props.details.get(a.DISCONNECTED),this.props.details.get(a.ADMIN),this.props.details.get(a.HOST)),this.props.details.get(a.DISCONNECTED)?e="gray":this.props.details.get(a.ADMIN)?e="red":this.props.details.get(a.HOST)&&(e="green"),React.createElement("div",{className:"play-playerInPlayerList"},React.createElement("p",{style:{color:e,fontWeight:this.props.details.get(a.HOST)||this.props.details.get(a.ADMIN)||this.props.details.get(a.DISCONNECTED)?"bold":"none"}},this.props.number,". ",this.props.name),this.props.buttons&&this.props.buttons.map((e,t)=>e.onClick?React.createElement("button",{className:"play-actionButton",key:Math.random(),onClick:t=>e.onClick(t)},e.text):React.createElement("span",{className:"play-playerBadge",key:Math.random()},e.text)))}}a.DEAD=0,a.HOST=1,a.ADMIN=2,a.DISCONNECTED=3,a.TARGETS=4,a.TAREGT_SELF=5,a.TARGET_DEAD=6,a.CAN_FM=7,r.default=a},{}],5:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0}),r.default=function(e){const t=[];let r=1;for(let a of e.players)t.push(React.createElement(s.default,{buttons:a.buttons,name:a.name,details:a.details,number:r,key:Math.random()})),r++;return React.createElement("div",{className:"play-playerList"},t)};var a,n=e("./Player"),s=(a=n)&&a.__esModule?a:{default:a}},{"./Player":4}],6:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});var a=p(e("./PlayerList")),n=p(e("./GraveyardBox")),s=p(e("./RolelistBox")),o=p(e("../Other/Commands")),i=p(e("../Other/Bitfield")),l=p(e("./Player"));function p(e){return e&&e.__esModule?e:{default:e}}function c(e,t,r,a=!1){const n=[];return t.id===r.id&&n.push({text:"YOU"}),!t.details.get(l.default.ADMIN)||r.details.get(l.default.ADMIN)||r.id===t.id||a||n.push({text:"kick",onClick:()=>o.default.run("/kick "+r.name,e)}),!t.details.get(l.default.ADMIN)&&!t.details.get(l.default.HOST)||r.id!=t.id||a||n.push({text:"start game",onClick:async()=>{if(!(await e.getRequest(`start?lobbyId=${e.player.lobbyId}&starter=${t.id}`)).res)return e.addMessage("Failed to start the game! The game must have at least 3 players.")}}),n}class u extends React.Component{constructor(e){super(e),this.state={players:[],rolelist:[]},e.app.setThisPlayerAsAdmin=()=>{this.setState(e=>{const t=this.thisPlayer();t.admin=!0;for(let r of e.players)r.buttons=c(this.props.app,t,r,this.props.app.started);return e})}}componentDidMount(){this.props.app.player.on("lobbyInfo",e=>{this.props.app.player.name=e.yourName;const t=e.players.find(t=>t.name===e.yourName);t.details=new i.default(t.details);try{for(let r of e.players)r.id!==t.id&&(r.details=new i.default(r.details)),r.buttons=c(this.props.app,t,r,this.props.app.started),console.log(r)}catch(e){console.log(e)}this.setState({players:e.players,rolelist:e.rl})}),this.props.app.player.on("rolelistChange",e=>{this.props.app.addMessage({content:`The rolelist was changed by ${e.changedBy}!`,sender:"system"}),this.setState(t=>{const r=t.rolelist.concat();return r[Number(e.index)]=e.content,{rolelist:r}})}),this.props.app.player.on("playerTempDisconnect",e=>{this.setState(t=>{const r=t.players.find(t=>t.id===e.id);return r?(r.details.update(l.default.DISCONNECTED),t):{}})}),this.props.app.player.on("playerLeave",e=>{this.setState(t=>{const r=t.players.find(t=>t.id===e.id);if(!r)return;this.props.app.addMessage({content:r.name+" left the game!",sender:"system"});const a=t.players.findIndex(t=>t.id===e.id),n=t.players.concat();n.splice(a,1),n.forEach(e=>{e.number>a+1&&e.number--}),n[0]&&!n[0].details.get(l.default.HOST)&&n[0].details.update(l.default.HOST);const s=t.rolelist.concat();return s.splice(s.length-1,1),{players:n,rolelist:s}})}),this.props.app.player.on("playerJoin",e=>{this.setState(t=>{this.props.app.addMessage({content:e.name+" has joined the game!",sender:"system"}),e.buttons=c(this.props.app,this.thisPlayer(),e,this.props.app.started),e.details=new i.default(e.details);const r=t.players.concat();r.push(e);const a=t.rolelist.concat();return a.push("Any"),{players:r,rolelist:a}})}),this.props.app.player.on("playerReconnect",e=>{this.setState(t=>{const r=t.players.find(t=>t.id===e.id);if(r)return r.details.clear(l.default.DISCONNECTED),t})}),this.props.app.player.on("admin",e=>{this.setState(t=>{const r=t.players.find(t=>t.id===e.id);if(r)return r.details.update(l.default.ADMIN),r.buttons=c(this.props.app,this.thisPlayer(),e,this.props.app.started),t})}),this.props.app.player.on("start",e=>{this.props.app.started=!0,this.props.app.addMessage({content:"The game has started! Your role is "+e.role,sender:"system"}),this.setState(t=>{const r=t.players.concat();for(let t of r)t.buttons=c(this.props.app,this.thisPlayer(),e,!0);return{players:r}})}),this.props.app.player.on("win",e=>{this.props.app.addMessage({content:e.winners+" win!"})})}render(){return React.createElement(React.Fragment,null,React.createElement(a.default,{app:this.props.app,players:this.state.players.filter(e=>!e.dead)}),React.createElement(n.default,{app:this.props.app,players:this.state.players.map(e=>e.dead)}),React.createElement(s.default,{app:this.props.app,rolelist:this.state.rolelist,thisPlayer:this.thisPlayer.bind(this)}))}thisPlayer(){return this.state.players.find(e=>e.id===this.props.app.player.id)}}r.default=u},{"../Other/Bitfield":8,"../Other/Commands":9,"./GraveyardBox":3,"./Player":4,"./PlayerList":5,"./RolelistBox":7}],7:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});var a,n=e("./Player"),s=(a=n)&&a.__esModule?a:{default:a};class o extends React.Component{constructor(e){super(e),this.state={value:this.props.content||""}}render(){const e=this.props.thisPlayer();return React.createElement("input",{className:"play-rolelistSlot",type:"text",disabled:!!e&&(!0!==e.details.get(s.default.ADMIN)&&!0!==e.details.get(s.default.HOST)),value:this.state.value,onChange:e=>this.setState({value:e.target.value}),onKeyUp:async e=>{if(13===e.keyCode){const t=e.target.value.replace(/\s+/g," ").trim();if(""===t)return e.target.value="Any";e.persist(),!1===(await this.props.app.getRequest(`changerl?index=${this.props.index}&content=${t}&lobbyId=${this.props.app.player.lobbyId}&setter=${this.props.app.player.id}`)).res&&(e.target.value="Any",this.props.app.addMessage({content:"This is an invalid rolelist entry.",sender:"system"})),e.preventDefault()}}})}}class i extends React.Component{constructor(e){super(e)}render(){const e=this.props.rolelist.map((e,t)=>React.createElement(o,{content:e,key:Math.random(),index:t,app:this.props.app,thisPlayer:this.props.thisPlayer}));return React.createElement("div",{className:"play-rolelistBox"},e.length&&e||"")}}r.default=i},{"./Player":4}],8:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});r.default=class{constructor(e=0){this.bits=e}get(e){return 0!=(this.bits&1<<e)}set(e){this.bits|=e}raw(e){return this.bits&1<<e}clear(e){this.bits=this.bits&~(1<<e)}update(e){this.bits=this.bits|1<<e}}},{}],9:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0}),r.default={run:async function(e,t){const r=e.split(" "),a=r.shift();if("/admin"===a){if(!r.length)return!0;return(await t.getRequest(`pwd?password=${r[0]}&player=${t.player.id}&lobbyId=${t.player.lobbyId}`)).res?(t.addMessage({content:"You are now an admin!",sender:"system"}),t.setThisPlayerAsAdmin(),!0):t.addMessage({content:"Wrong password!",sender:"system"})}if("/kick"===a){if(!r.length)return!0;return(await t.getRequest(`kick?player=${r[0]}&kicker=${t.player.id}&lobbyId=${t.player.lobbyId}`)).res?t.addMessage({content:"Player kicked!",sender:"system"}):t.addMessage({content:"Something went wrong! You most likely entered a player that doesn't exist!",sender:"system"}),!0}if("/w"===a){if(!r.length)return!0;const e=r.shift(),a=r.join(" ");(await t.getRequest(`whisper?whisperer=${t.player.id}&receiver=${e}&lobbyId=${t.player.lobbyId}&msg=${a}`)).res?t.addMessage({content:"Player kicked!",sender:"system"}):t.addMessage({content:"Something went wrong!",sender:"system"})}return!1},cmds:["/admin","/kick","/w"]}},{}],10:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});const a="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";class n extends EventEmitter3{constructor(e,t){super(),this.lobbyId=t,this.name=e,this.ready=!1,sessionStorage.setItem("_room_",t),this.id=sessionStorage.getItem("_sid_"),this.id||(this.id=n.genid(),sessionStorage.setItem("_sid_",this.id)),this.socket=new WebSocket(`ws://localhost:4000?roomId=${t}&name=${e}&socketId=${this.id}`),this.socket.onopen=()=>{this.ready=!0,this.emit("ready",this),this.socket.onmessage=e=>{try{const t=JSON.parse(e.data);t.e&&this.emit(t.e,t.d)}catch(e){return}},this.socket.onerror=e=>this.emit("error",e),this.socket.onclose=e=>this.emit("close",e)}}send(e,t){this.socket.send(JSON.stringify({e:e,d:t}))}static genid(e=18){let t="";for(let r=0;r<e;r++)t+=a.charAt(Math.floor(Math.random()*a.length));return t}}r.default=n},{}],11:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0}),r.default=function(e){const t=React.useRef();let r="";return React.createElement("div",{className:"container"},React.createElement("div",{className:"row home-center"},React.createElement("div",null,React.createElement("img",{src:"./logo.png"}),React.createElement("h1",null,"The Testing Grounds"),React.createElement("p",null,"Welcome to the Testing Grounds, where role ideas are tested in simulated gameplay. If you have any questions regarding the Testing Grounds, please view the ",React.createElement("a",{href:"https://www.blankmediagames.com/phpbb/viewtopic.php?f=50&t=72338",target:"_blank"},"FAQ"),". You can also ask questions and report bugs in our ",React.createElement("a",{href:"https://discord.com/invite/EVS55Zb",target:"_blank"},"discord server"),". Created by ",React.createElement("a",{href:"https://blankmediagames.com/phpbb/memberlist.php?mode=viewprofile&un=GoogleFeud",target:"_blank"},"GoogleFeud")," "),React.createElement("input",{type:"text",className:"home-input",placeholder:"Your name...",onInput:e=>{r=e.target.value}}),React.createElement("input",{type:"text",className:"home-name-input",disabled:!0,value:"1111"}),React.createElement("br",null),React.createElement("p",{ref:t,className:"home-error"}),React.createElement("button",{onClick:async n=>{if(n.persist(),r.length<=3)return t.current.innerHTML="Your username must be longer than 3 characters!";if(a.some(e=>r.includes(e)))return t.current.innerHTML=`Your name contains invalid characters! (${a.join(", ")})`;if(/\s/.test(r))return t.current.innerHTML="Currently, empty spaces are not allowed!";if(r.length>14)return t.current.innerHTML="Your name is too long!";const s=await e.app.getRequest("playersIn?roomId=1111");if(t.current){if(s.some(e=>e.toLowerCase()===r.toLowerCase()))return t.current.innerHTML="This username is taken!";e.app.joinGame(r,"1111"),t.current&&(n.target.disabled=!0,t.current.innerHTML="Please wait...")}}},"JOIN!"))),React.createElement("div",{className:"home-center"},React.createElement("iframe",{src:"https://discordapp.com/widget?id=239404476178366465&theme=dark",width:"350",height:"500",allowtransparency:"true",frameBorder:"0"})))};const a=["!",">","<","^","?","-","=","|","\\","/","@","%","&","*","(",")","+",":",";","~","{","}","[","]"]},{}],12:[function(e,t,r){"use strict";Object.defineProperty(r,"__esModule",{value:!0});var a=s(e("../Components/ChatBox")),n=s(e("../Components/PlayerManager"));function s(e){return e&&e.__esModule?e:{default:e}}class o extends React.Component{constructor(e){super(e),e.app.player.on("kick",()=>{e.app.goto("/"),location.reload()})}render(){return React.createElement("div",null,React.createElement(n.default,{app:this.props.app}),React.createElement(a.default,{app:this.props.app}))}}r.default=o},{"../Components/ChatBox":2,"../Components/PlayerManager":6}],13:[function(e,t,r){"use strict";e("regenerator-runtime");var a=o(e("./Pages/Home")),n=o(e("./Pages/Play")),s=o(e("./Other/WebSocket"));function o(e){return e&&e.__esModule?e:{default:e}}let i;const l={"/":a.default,"/play":n.default};class p extends React.Component{constructor(e){super(e);const t=this.resolveURL();this.state={url:t.path},this.player=null,this.started=!1,"/play"===t.path&&sessionStorage.getItem("_room_")&&sessionStorage.getItem("_sid_")?this.player=new s.default("a",sessionStorage.getItem("_room_")):this.state.url="/",window.history.pushState({url:this.state.url},null,this.state.url),window.onpopstate=e=>{if(e.state)return this.setState({path:e.state.url})}}render(){let e=l[this.state.url]||a.default;return React.createElement("div",null,React.createElement(e,{app:this}))}resolveURL(e){const t=new URL(e||location.href,(location.hostname,"http://localhost:4000"));return{path:t.pathname,query:t.searchParams,formed:t.toString()}}goto(e){l[e]||(e=this.resolveURL(e));let t=e.path||e;return window.history.pushState({url:e.formed||e},null,e.formed||e),this.setState({url:t}),null}joinGame(e,t){this.player=new s.default(e,t),this.goto("/play")}async getRequest(e){const t=await fetch("/api/"+e);return!!t.ok&&await t.json()}}window.onload=async()=>{i=document.getElementById("main"),ReactDOM.render(React.createElement(p,null),i)}},{"./Other/WebSocket":10,"./Pages/Home":11,"./Pages/Play":12,"regenerator-runtime":1}]},{},[13]);