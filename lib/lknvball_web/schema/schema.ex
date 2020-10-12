defmodule LknvballWeb.Schema do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema

  use Absinthe.Relay.Schema, flavor: :modern
  use Absinthe.Relay.Schema.Notation, :modern

  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(LknvballWeb.Schema.Enums)
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

  object :empty_payload do
    description("This mutation has no meaningful return")
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

      %Lknvball.Events.EventUser{}, _ ->
        :event_user

      _, _ ->
        nil
    end)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Lknvball.Accounts.User, Lknvball.Accounts.dataload_user())

    # additional sources

    Map.put(ctx, :loader, loader)
  end

  # default middleware that returns unauthorixed if no current user from token
  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
      when identifier in [:query, :subscription] do
    [LknvballWeb.Authentication] ++
      middleware
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    [LknvballWeb.Authentication] ++
      middleware ++
      [&build_payload/2]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
