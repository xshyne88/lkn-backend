defmodule LknvballWeb.Resolvers.Event do
  alias Absinthe.Relay.Connection
  alias Lknvball.Repo

  def get_events_connection(related, args, _ctx) do
    related
    |> Lknvball.Events.list_events(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def create_event(_, args, _) do
    Lknvball.Accounts.create_user(args)
  end

  # def get_users_connection(_, _, _), do: {:error, :unauthorized}
end
