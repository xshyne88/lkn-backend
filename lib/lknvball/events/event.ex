defmodule Lknvball.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:cost, :image, :name]}

  schema "events" do
    field :cost, :integer, default: 20
    field :image, :string
    field :name, :string
    field :start_time, :utc_datetime

    has_many :event_users, Lknvball.Events.EventUser

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :image, :cost, :start_time])
    |> validate_required([:name, :cost])
  end
end
