defmodule Discuss.Repo.Migrations.Addcomments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users_elixir)
      add :topic_id, references(:topics)
      timestamps()
    end
  end
end
