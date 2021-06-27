defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  alias Discuss.User
  alias Discuss.Repo

  import Routes

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: "github"
    }

    sign_in(conn, user_params)
  end

  defp sign_in(conn, user_params) do
    case insert_or_update_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(user_params) do
    case Repo.get_by(User, email: user_params.email) do
      nil ->
        User.changeset(%User{}, user_params) |> Discuss.Repo.insert
      user ->
        User.changeset(user, user_params) |> Discuss.Repo.update
    end
  end
end
