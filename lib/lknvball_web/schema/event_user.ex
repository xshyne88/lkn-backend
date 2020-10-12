defmodule LknvballWeb.Schema.EventUser do
  alias Lknvball.Accounts
  alias Lknvball.Events

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  connection(node_type: :event_user)

  node object(:event_user) do
    field(:paid, :boolean)

    field(:event, non_null(:event)) do
      resolve(fn %{event_id: event_id}, _, _ -> {:ok, Events.get_event!(event_id)} end)
    end

    field(:user, :user, resolve: dataloader(Accounts.User))
  end
end
