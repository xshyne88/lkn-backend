defmodule Lknvball.Events.EventUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_users" do
    field :paid, :boolean, default: false
    field :user_id, :id
    field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(event_users, attrs) do
    event_users
    |> cast(attrs, [:paid])
    |> validate_required([:paid])
  end
end
