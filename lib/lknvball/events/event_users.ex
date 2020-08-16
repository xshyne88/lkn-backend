defmodule Lknvball.Events.EventUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_users" do
    field :paid, :boolean, default: false
    field :user_id, :id
    field :event_id, :id
    field :guest_name, :string

    timestamps()
  end

  @doc false
  def changeset(event_users, attrs) do
    event_users
    |> cast(attrs, [:paid, :guest_name])
    |> validate_required([:paid, :event_id])
  end
end
