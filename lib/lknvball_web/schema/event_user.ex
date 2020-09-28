defmodule LknvballWeb.Schema.EventUser do
  alias LknvballWeb.Resolvers

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  connection(node_type: :event_user)

  node object(:event_user) do
    field(:paid, :boolean)

    field(:event, non_null(:event)) do
      resolve(fn %{event_id: event_id}, _, _ -> {:ok, Lknvball.Events.get_event!(event_id)} end)
    end

    field(:user, :user) do
      resolve(fn
        %{user_id: nil}, _, _ -> {:ok, nil}
        %{user_id: user_id}, _, _ -> {:ok, Lknvball.Accounts.get_user!(user_id)}
      end)
    end
  end
end
