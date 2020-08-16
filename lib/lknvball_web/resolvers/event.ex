defmodule LknvballWeb.Resolvers.Event do
  alias Absinthe.Relay.Connection
  alias Lknvball.Repo

  def get_events_connection(related, args, _ctx) do
    related
    |> Lknvball.Events.list_events(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_node(related, %{id: id}, ctx) do
    IO.inspect(ctx.context)
    IO.inspect(id, label: "id")
    {:ok, Lknvball.Events.get_event!(id)}
  end

  def get_node(_, _ ,_ ) do
    {:error, "expected id for event node"}
  end

  def create_event(_, args, _) do
    Lknvball.Accounts.create_user(args)
  end

  # def get_users_connection(_, _, _), do: {:error, :unauthorized}
end
