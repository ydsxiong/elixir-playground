// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"
// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})
// connect if there are any LiveViews on the page
liveSocket.connect()
// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

let roomName = "chat_room:lobby";
let newMsgLabel = "new_msg";
let chatInput = document.querySelector("#chat-input");
let messageContainer = document.querySelector("#messages");

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"
let chatSocket = new Socket("/socket", {params: {token: window.userToken}});
chatSocket.connect();
let chatChannel = chatSocket.channel(roomName, {});

// join the chat room and notify the server 
chatChannel.join().receive("ok", resp => console.log("Joined successfully", resp));

// listening on server's broadcasts in this room
chatChannel.on(newMsgLabel, renderMessage);

// on any one client's new msg input, push new message to the server,
// which in turn could broadcast it to all clients joining in the same room
chatInput.addEventListener("keypress", publishEvent);

function renderMessage(payload) {
    let messageItem = document.createElement("li");
    messageItem.innerText = `[${Date()}]  ${payload.message}`
    messageContainer.appendChild(messageItem);
}

function publishEvent(event) {
    // check for only the 'enter'(13) key stroke
    if (event.keyCode == 13) {
        chatChannel.push(newMsgLabel, {message: chatInput.value});
        chatInput.value = '';
    }
}

export default chatSocket




