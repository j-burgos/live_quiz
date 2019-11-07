// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("game:lobby", {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("chat:message", (payload) => {
  console.group("Chat message")
  console.log(payload)
  console.groupEnd()
  const { message } = payload;
  const buildChatMessage = (messageText) => `
    <div class="item">
      <div class="ui compact message">${messageText}</div>
    </div>
  `
  const chatboxElem = $("#chatbox")
  chatboxElem.append(buildChatMessage(message));
  chatboxElem.animate({ scrollTop: chatboxElem.prop("scrollHeight") }, 500);
})

channel.on("game:question", (payload) => {
  console.group("Question received")
  console.log(payload)
  console.groupEnd()
  const { question: { id: questionId, content: questionText }, options } = payload;
  const questionModal = $('#question-modal')
  const questionIdInput = questionModal.find('#question-id')
  const questionTextElem = questionModal.find('.description > .header')
  questionIdInput.val(questionId)
  questionTextElem.html(questionText)
  const buildOptionTemplate = ({ id, content }) => `
    <div class="ui basic segment padded">
      <div id="${id}" class="ui fluid huge button">${content}</div>
    </div>
  `
  const optionsContent = options.map(buildOptionTemplate);
  const optionsElem = questionModal.find('.options')
  $(document.body).off('click', '#question-modal .options .button')
  optionsElem.empty()
  optionsElem.html(optionsContent)
  $(document.body).on('click', '#question-modal .options .button', (event) => {
    const currentElem = event.currentTarget
    const answerId = currentElem.id
    const questionId = $('#question-id').val()
    console.group("answer")
    console.log(questionId)
    console.log(currentElem.id)
    console.groupEnd()
    channel.push("game:answer", { questionId, answerId })
  })
  questionModal
    .modal({ closable: false })
    .modal('show')
})

channel.on("game:result", (payload) => {
  console.group("Answer result")
  console.log(payload)
  console.groupEnd()
  const { optionId, result } = payload
  const animation = result ? 'bounce' : 'shake'
  const colorClass = result ? 'positive' : 'negative'
  const questionModal = $('#question-modal')
  questionModal.find(`#${optionId}`).toggleClass(colorClass).transition({
    animation,
    duration: 1000,
    onComplete: () => {
      questionModal.modal('hide')
    }
  })
})

function broadcastQuestion(questionId) {
  channel.push("game:question:broadcast", { questionId })
}

function sendChatMessage(message) {
  channel.push("chat:message", { message })
}

export {
  broadcastQuestion,
  sendChatMessage
}

export default socket

