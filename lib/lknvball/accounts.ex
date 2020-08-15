defmodule Lknvball.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Lknvball.Accounts.User
  alias Lknvball.Repo
  alias LknvballWeb.Guardian

  @doc """
  Begins registration process for oauth2 facebook sign in.
  """
  def register(%{provider: :facebook} = params) do
    with {:ok, %{upserted_user: user}} <- upsert_user(params, tx: true),
         {:ok, striped_user} <- upsert_stripe_user(user),
         {:ok, token, _claims} <- make_token(striped_user) do
      {:ok, token}
    else
      {:error, _} = tuple_error -> tuple_error
      err -> {:error, err}
    end
  end

  def register(_), do: {:error, "check register oauth function, something went wrong"}

  def make_token(striped_user) do
    striped_user
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Guardian.encode_and_sign()
  end

  def upsert_stripe_user(%{stripe_customer_id: nil, email: email} = user) do
    %{email: email}
    |> Stripe.Customer.create()
    |> handle_stripe_create_user(user)
  end

  def upsert_stripe_user(%{stripe_customer_id: stripe_customer_id, email: email} = user) do
    case Stripe.Customer.retrieve(stripe_customer_id) do
      {:ok, %Stripe.Customer{id: id}} ->
        {:ok, user}

      {:error, %Stripe.Error{extra: %{http_status: 404}}} ->
        email
        |> Stripe.Customer.create()
        |> handle_stripe_create_user(user)
    end
  end

  def handle_stripe_create_user({:ok, %Stripe.Customer{id: id}}, user) do
    update_user(user, %{stripe_customer_id: id})
  end

  def handle_stripe_create_user(err, _user), do: err

  @doc """
  finds a user based on crtierion as a transaction

  iex> upsert_user(field: criterion, tx: true)
  %{ok, %{upserted_user: %User{}}

  """
  def upsert_user(params, tx: true) do
    Multi.new()
    |> Multi.run(:upserted_user, fn _, _ -> upsert_user(params) end)
    |> Repo.transaction()
  end

  @doc """
  finds or inserts a user based on params

  ## Examples

  iex> upsert_user(%{email: "foo@bar.com"})
  %User{}

  """
  def upsert_user(%{email: email} = params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id, :stripe_customer_id, :inserted_at, :updated_at]},
      conflict_target: :email,
      returning: true
    )
  end

  def upsert_user(_), do: {:error, "please include email when upserting a user"}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users(_, _) do
    User
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
