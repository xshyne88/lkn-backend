defmodule LknvballWeb.Schema.User do
  import AbsintheErrorPayload.Payload

  alias LknvballWeb.Resolvers

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  connection(node_type: :user)

  node object(:user) do
    field(:email, non_null(:string))
    field(:admin, non_null(:boolean))
  end

  object :user_queries do
    connection field(:users, node_type: :user) do
      resolve(&Resolvers.User.get_users_connection/3)
    end
  end

  input_object :user_input do
    field(:id, :id)
    field(:email, non_null(:string))
    field(:admin, non_null(:boolean))
  end

  payload_object(:create_user_payload, :user)

  object :user_mutations do
    field(:create_user, :create_user_payload) do
      arg(:input, non_null(:user_input))

      resolve(&Resolvers.User.create_user/3)
    end
  end
end

# def from_dataloader(loader, source_name, resource, parent, options) do
#   # NOTE: The user should provide the `max` field, but this is just for demonstration purposes.
#   opts = [max: options[:max] || 100]
#   # NOTE: The user must provide the `sort` field, but this is just for demonstration purposes.
#   sort = options[:sort] || [%{asc: :inserted_at}]
#   pagination_args = Keyword.fetch!(options, :pagination_args)

#   with {:ok, offset, limit} <- Connection.offset_and_limit_for_query(pagination_args, opts) do
#     args = %{sort: sort, limit: limit, offset: offset}

#     loader
#     |> Dataloader.load(source_name, {resource, args}, parent)
#     |> on_load(fn loader ->
#       records = Dataloader.get(loader, source_name, {resource, args}, parent)

#       opts =
#         opts
#         |> Keyword.put(:has_previous_page, offset > 0)
#         |> Keyword.put(:has_next_page, length(records) > limit)

#       Connection.from_slice(Enum.take(records, limit), offset, opts)
#     end)
#   end
# end
