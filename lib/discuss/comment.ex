defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Repo
  import Ecto

  @derive {Jason.Encoder, only: [:content, :user]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :topic_id, :user_id])
    |> cast_assoc(:topic)
    |> cast_assoc(:user)
    |> validate_required([:content])
  end

  def create(content, topic_id, user_id) do
    %Discuss.Comment{}
    |> changeset(%{content: content, topic_id: topic_id, user_id: user_id})
    |> Repo.insert()
  end

  def getCommentsFromTopic(topic_id) do
    Repo.get_by(Discuss.Comment, topic_id: topic_id)
  end
end
