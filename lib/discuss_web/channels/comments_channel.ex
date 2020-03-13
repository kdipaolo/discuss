defmodule Discuss.CommentsChannel do
  use Phoenix.Channel
  alias Discuss.Topic

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic.getTopicWithComments(topic_id)
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do
    topic_id = socket.assigns.topic.id
    user_id = socket.assigns.user_id

    case Discuss.Comment.create(content, topic_id, user_id) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{errors: ""}}, socket}
    end
  end
end
