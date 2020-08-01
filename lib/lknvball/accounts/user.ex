defmodule Lknvball.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:email, :image, :name, :admin, :id, :stripe_customer_id]}

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :image, :string
    field :name, :string
    field :password, :string

    field :stripe_customer_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:admin, :email, :name, :image, :password, :stripe_customer_id])
    |> validate_required([:admin, :email])
    |> unique_constraint(:email)
  end
end
