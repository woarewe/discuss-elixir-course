defmodule Discuss.Repo.Migrations.AddUserIdToTopics do
  use Ecto.Migration

  def up do
    alter table(:topics) do
      add(:user_id, :integer)
    end
  end

  def down do
    alter table(:topics) do
      remove(:user_id)
    end
  end
end
