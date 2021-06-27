defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string

      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
