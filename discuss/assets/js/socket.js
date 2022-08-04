import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createChannel = (topicId) => {
   console.log("client joined in channnel for topic: " + topicId);
      let channel = socket.channel(`comments:${topicId}`, {})

      channel.join()
         .receive("ok", resp => { 
            console.log(resp);
            renderComments(resp.comments);
         })
         .receive("error", resp => { console.log("Unable to join channel", resp) })

         document.querySelector('button').addEventListener('click', function(){
            const content = document.querySelector('textarea').value
            channel.push('comment:add', { content: content});
         });

//   <button>Ping!</button>  
// document.querySelector('button').addEventListener('click', function(){
//   channel.push('comment:hello', { hi: "Stephen"});
// });
   channel.on(`comments:${topicId}:new`, renderComment);
}

//export default socket

window.createChannel = createChannel;

function renderComments(comments) {
   const renderedComments = comments.map(comment => renderCommmentCommon(comment));

   document.querySelector('.collection').innerHTML = renderedComments.join('');
}

function renderComment(event) {
   const renderedComment = renderCommmentCommon(event.comment);

   document.querySelector('.collection').innerHTML += renderedComment;
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