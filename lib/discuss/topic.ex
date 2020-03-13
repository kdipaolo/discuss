defmodule Discuss.Topic do
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Queryable
  alias Discuss.Repo
  import Ecto

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end

  def create(topic, user) do
    changeset =
      user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    Repo.insert(changeset)
  end

  def get do
    Repo.all(__MODULE__)
  end

  def getOne(id) do
    Repo.get(__MODULE__, id)
  end

  def update(topic) do
    Repo.update(topic)
  end

  def delete(id) do
    Repo.get!(__MODULE__, id) |> Repo.delete!()
  end

  def getTopicWithComments(topic_id) do
    Repo.get(Discuss.Topic, topic_id)
    |> Repo.preload(comments: [:user])
  end
end
