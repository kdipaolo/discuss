defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Topic.get()
    IO.inspect(conn.assigns)
    render(conn, "index.html", topics: topics, user: conn.assigns.user)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    topics = Topic.get()

    case Topic.create(topic, conn.assigns.user) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Topic.getOne(id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def show(conn, %{"id" => id}) do
    topic = Topic.getOne(id)
    render(conn, "show.html", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    changeset = Topic.getOne(id) |> Topic.changeset(topic)

    case Topic.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Topic.delete(id)

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    topic = Topic.getOne(topic_id)
    IO.inspect("LDSFJDSLKFKLF")
    IO.inspect(topic)

    if conn.assigns.user.id == topic.user_id do
      conn
    else
      conn
      |> put_flash(:error, "You cant edit this!")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
