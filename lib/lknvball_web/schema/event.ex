defmodule LknvballWeb.Schema.Event do
  import AbsintheErrorPayload.Payload

  alias LknvballWeb.Resolvers

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  connection(node_type: :event)

  node object(:event) do
    field(:name, :string)
    field(:image, :string)
    field(:cost, :integer)
    field(:start_time, :string)

    connection field(:participants, node_type: :event_user) do
      resolve(&Resolvers.Event.get_participants_connection/3)
    end
  end

  input_object :event_sort_by do
    field(:cost, :sort_direction)
    field(:name, :sort_direction)
  end

  object :event_queries do
    connection field(:events, node_type: :event) do
      arg(:sort_by, :event_sort_by)
      # middleware(LknvballWeb.Authentication)
      resolve(&Resolvers.Event.get_events_connection/3)
    end

    connection field(:past_events, node_type: :event) do
      # middleware(LknvballWeb.Authentication)
      resolve(&Resolvers.Event.get_past_events_connection/3)
    end

    connection field(:future_events, node_type: :event) do
      # middleware(LknvballWeb.Authentication)
      resolve(&Resolvers.Event.get_future_events_connection/3)
    end

    field(:event, non_null(:event)) do
      arg(:id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, id: :event)
      resolve(&Resolvers.Event.get_node/3)
    end
  end

  input_object :sign_up_input do
    field(:event_id, non_null(:id))
  end

  payload_object(:sign_up_payload, :empty_payload)

  input_object :event_input do
    field(:id, :id)
    # field(:email, non_null(:string))
    # field(:admin, non_null(:boolean))
    field(:cost, non_null(:integer))
    field(:name, non_null(:string))
    field(:img_url, non_null(:string))
    # field(:start_time, non_null(:utc_datetime)) TODO: Datetime
  end

  payload_object(:create_event_payload, :event)

  payload_object(:update_event_payload, :event)

  object :event_mutations do
    field(:sign_up, :sign_up_payload) do
      arg(:input, non_null(:sign_up_input))

      middleware(Absinthe.Relay.Node.ParseIDs, input: [event_id: :event])
      resolve(&Resolvers.Event.sign_up/3)
    end

    field(:cancel_sign_up, :sign_up_payload) do
      arg(:input, non_null(:sign_up_input))

      middleware(Absinthe.Relay.Node.ParseIDs, input: [event_id: :event])
      resolve(&Resolvers.Event.cancel_sign_up/3)
    end

    field(:create_event, :create_event_payload) do
      arg(:input, non_null(:event_input))

      middleware(LknvballWeb.Role, :admin)
      resolve(&Resolvers.Event.create_event/3)
    end

    field(:update_event, :update_event_payload) do
      arg(:input, non_null(:event_input))

      middleware(LknvballWeb.Role, :admin)
      middleware(Absinthe.Relay.Node.ParseIDs, input: [id: :event])
      resolve(&Resolvers.Event.update_event/3)
    end
  end
end
