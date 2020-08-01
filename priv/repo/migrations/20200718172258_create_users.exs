defmodule Lknvball.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :admin, :boolean, default: false, null: false
      add :email, :string
      add :name, :string
      add :image, :string
      add :password, :string

      add :stripe_customer_id, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
