import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

window.createChannel = (topicId) => {
   console.log("client joined in channnel for topic: " + topicId);
   let channel = socket.channel(`comments:${topicId}`, {});
   let btnAdd = document.querySelector('button');
   let commentInput = document.querySelector('textarea');
   let commentContainer = document.querySelector('.collection');
   
   // join the channel and notify the server:
   channel.join().receive("ok", setupCommentsRenderOnJoiningChannel(commentContainer));

   // listening on the broadcast from the server
   channel.on(`comments:${topicId}:new`, setupCommentRender(commentContainer));

   // publish new comment to the server
   btnAdd.addEventListener('click', setupCommentPublisher(channel, commentInput));
}

function setupCommentsRenderOnJoiningChannel(commentContainer) { 
   return (payload) => {
         console.log(payload);
         renderComments(payload.comments, commentContainer);
   }
}

function setupCommentPublisher(channel, commentInput) {
   return (_event) => {
         channel.push('comment:add', { content: commentInput.value});
         commentInput.value = '';
   }
}

function setupCommentRender(commentContainer) {
   return (payload) => {
         let renderedComment = renderCommmentCommon(payload.comment);
         commentContainer.innerHTML += renderedComment;
   }
}

function renderComments(comments, commentContainer) {
   let renderedComments = comments.map(comment => renderCommmentCommon(comment));
   commentContainer.innerHTML = renderedComments.join('');
}

function renderCommmentCommon(comment) {
   let email = "Anonymous"
   if (comment.user) {
      email = comment.user.email;
   }
   return `
      <li class="collection-item"> 
            ${comment.content}
            <div class="secondary-content">
                  ${email}
            </div>
      </li> 
   `;
}

//export default socket

//   <button>Ping!</button>  
// document.querySelector('button').addEventListener('click', function(){
//   channel.push('comment:hello', { hi: "Stephen"});
// });