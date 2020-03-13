defmodule Discuss.User do
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Repo

  @derive {Jason.Encoder, only: [:email]}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :topics, Discuss.Topic
    has_many :comments, Dicuss.Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end

  def create(user) do
    IO.puts("++++++++++++++++++++++++++++")
    IO.inspect(user)
    IO.puts("++++++++++++++++++++++++++++")
    Repo.insert(changeset(%User{}, user))
  end

  def getOne(id) do
    Repo.get(__MODULE__, id)
  end

  def getByEmail(value) do
    Repo.get_by(__MODULE__, email: value)
  end
end
