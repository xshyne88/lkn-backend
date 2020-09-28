defmodule Lknvball.Repo.Migrations.CreateEventUsers do
  use Ecto.Migration

  @table :event_users

  def change do
    create table(@table) do
      add :paid, :boolean, default: false, null: false
      add :guest_name, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps()
    end

    create(unique_index(@table, [:user_id, :event_id], name: :event_users_key))

    create index(:event_users, [:user_id])
    create index(:event_users, [:event_id])
  end
end
