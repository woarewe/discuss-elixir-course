defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  import DiscussWeb.Router.Helpers

  def init(_), do: nil

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
