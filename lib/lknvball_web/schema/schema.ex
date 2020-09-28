defmodule LknvballWeb.Schema do
  use Absinthe.Schema

  use Absinthe.Relay.Schema, flavor: :modern
  use Absinthe.Relay.Schema.Notation, :modern

  import_types(LknvballWeb.Schema.User)
  import_types(LknvballWeb.Schema.Event)
  import_types(LknvballWeb.Schema.EventUser)

  query do
    import_fields(:user_queries)
    import_fields(:event_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:event_mutations)
  end

  # subscription do
  # end

  # node field do
  #   %{type: :event, id: id}, _ ->
  #     {:ok, Map.get(@event, id)}
  # end

  node interface do
    resolve_type(fn
      %Lknvball.Accounts.User{}, _ ->
        :user

      %Lknvball.Events.Event{}, _ ->
        :event

      %Lknvball.Events.EventUsers{}, _ ->
        :event_user

      _, _ ->
        nil
    end)
  end

  # default middleware that returns unauthorixed if no current user from token
  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
      when identifier in [:query, :subscription, :mutation] do
    [LknvballWeb.Authentication | middleware]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
