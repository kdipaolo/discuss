import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });

socket.connect();

const comments = document.querySelector(".comments");
const button = document.querySelector(".btn");
const textarea = document.querySelector("textarea");

const createSocket = topicId => {
  let channel = socket.channel(`comments:${topicId}`, {});
  channel
    .join()
    .receive("ok", success)
    .receive("error", error);

  channel.on(`comments:${topicId}:new`, newComment);

  button.addEventListener("click", () => {
    const { value } = textarea;
    channel.push("comment:add", { content: value });
  });
};

const li = (comment, user) =>
  `<li class="collection-item">${comment}<div class="secondary-content">${user}</div></li>`;

const success = resp => {
  console.log("Joined successfully", resp);
  comments.innerHTML = resp.comments
    .map(c => li(c.content, c.user ? c.user.email : "Annonomouse"))
    .join("");
};

const error = resp => {
  console.log("Unable to join", resp);
};

const newComment = resp => {
  comments.innerHTML += li(resp.comment.content);
};

window.createSocket = createSocket;
