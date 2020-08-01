defmodule LknvballWeb.Resolvers.User do
  alias Absinthe.Relay.Connection
  alias Lknvball.Repo

  def get_users_connection(related, args, _) do
    related
    |> Lknvball.Accounts.list_users(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def create_user(_, args, _) do
    Lknvball.Accounts.create_user(args)
  end

  # def get_users_connection(_, _, _), do: {:error, :unauthorized}
end
