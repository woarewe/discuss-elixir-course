defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :update, :edit, :destroy]
  plug :check_topic_owner when action in [:update, :edit, :destroy]

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset  = conn.assigns.user
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(topic)

    case Discuss.Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    topics = Discuss.Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Discuss.Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = Discuss.Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic, topic_params)

    case Discuss.Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Successfully updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} -> render conn, "edit.html", changeset: changeset, topic: topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Discuss.Repo.get!(Topic, topic_id) |> Discuss.Repo.delete!

    conn
    |> put_flash(:info, "Topic was deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    topic = Discuss.Repo.get(Topic, topic_id)
    if topic.user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You don't have access to this")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
