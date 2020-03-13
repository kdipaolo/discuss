defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias Discuss.User
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    signin(conn, user_params)
  end

  def signin(conn, params) do
    case insert_or_update_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome Back")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(params) do
    IO.inspect("______________")
    IO.inspect(params)
    IO.inspect("______________")

    case User.getByEmail(params.email) do
      user -> {:ok, user}
      nil -> User.create(params)
    end
  end

  def signout(conn, params) do
    IO.inspect("WHOA")

    conn
    # Removes all cookies from a users session
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def what(conn, params) do
    IO.inspect("okay")
    conn
  end
end

# - Cookies are encrypted
# - Cookies go along the ride with every request
# - Cookies are not share across domains, they are domain specific
