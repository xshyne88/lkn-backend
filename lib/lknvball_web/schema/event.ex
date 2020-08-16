defmodule LknvballWeb.Schema.Event do
  alias LknvballWeb.Resolvers

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  connection(node_type: :event)

  node object(:event) do
    field(:name, :string)
    field(:image, :string)
    field(:cost, :integer)
    field(:start_time, :string)
  end

  object :event_queries do
    connection field(:events, node_type: :event) do
      resolve(&Resolvers.Event.get_events_connection/3)
    end
    field(:event, non_null(:event)) do
      arg :id, non_null(:id)

      middleware Absinthe.Relay.Node.ParseIDs, id: :event
      resolve(&Resolvers.Event.get_node/3)
    end
  end

  input_object :event_input do
    field(:id, :id)
    field(:email, non_null(:string))
    field(:admin, non_null(:boolean))
  end

  object :create_event_payload do
    field(:edge, :event_edge)
    field(:success, :boolean)
  end

  object :event_mutations do
    field(:create_event, :create_event_payload) do
      arg(:input, non_null(:event_input))

      resolve(&Resolvers.Event.create_event/3)
    end
  end
end
