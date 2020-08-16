defmodule LknvballWeb.Schema do
  use Absinthe.Schema

  use Absinthe.Relay.Schema, flavor: :modern
  use Absinthe.Relay.Schema.Notation, :modern

  import_types(LknvballWeb.Schema.User)
  import_types(LknvballWeb.Schema.Event)

  query do
    import_fields(:user_queries)
    import_fields(:event_queries)
  end

  mutation do
    import_fields(:user_mutations)
  end

  # subscription do
  # end

  node interface do
    resolve_type(fn
      %Lknvball.Accounts.User{}, _ ->
        :user

      %Lknvball.Events.Event{}, _ ->
        :event

      _, _ ->
        nil
    end)
  end
end
