defmodule Lknvball.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :cost, :integer
    field :image, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :image, :cost])
    |> validate_required([:name, :image, :cost])
  end
end
