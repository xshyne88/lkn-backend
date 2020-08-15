defmodule Lknvball.Repo.Migrations.CreateEventUsers do
  use Ecto.Migration

  def change do
    create table(:event_users) do
      add :paid, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:event_users, [:user_id])
    create index(:event_users, [:event_id])
  end
end
