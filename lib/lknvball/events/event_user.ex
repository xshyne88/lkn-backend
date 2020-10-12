defmodule Lknvball.Events.EventUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_users" do
    field :paid, :boolean, default: false
    field :guest_name, :string

    belongs_to :user, Lknvball.Accounts.User
    belongs_to :event, Lknvball.Events.Event

    timestamps()
  end

  @doc false
  def changeset(event_user, attrs) do
    event_user
    |> cast(attrs, [:paid, :event_id, :guest_name, :user_id])
    |> validate_required([:paid, :event_id])
    |> unique_constraint(:user_id, name: :event_users_key)
  end
end
