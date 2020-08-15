defmodule Lknvball.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :image, :string
      add :cost, :integer
      add :start_time, :utc_datetime

      timestamps()
    end

  end
end
