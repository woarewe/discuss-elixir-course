defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration

  def up do
    create table(:topics) do
      add(:title, :string)
    end
  end

  def down do
    drop table(:topics)
  end
end
