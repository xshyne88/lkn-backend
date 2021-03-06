defmodule Lknvball.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :image, :string
      add :cost, :integer, default: 20
      add :start_time, :utc_datetime

      timestamps()
    end

  end
end
