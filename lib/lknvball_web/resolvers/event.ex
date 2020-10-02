defmodule LknvballWeb.Resolvers.Event do
  alias Absinthe.Relay.Connection
  alias Lknvball.Repo
  alias Lknvball.Events

  ## GET EVENTS QUERY

  def get_events_connection(related, args, _ctx) do
    related
    |> Events.list_events(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_past_events_connection(related, args, _ctx) do
    related
    |> Events.list_past_events(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_future_events_connection(related, args, _ctx) do
    related
    |> Events.list_future_events(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_participants_connection(%{id: _} = related, args, _ctx) do
    related
    |> Events.list_participants()
    |> Connection.from_query(&Repo.all/1, args)
  end

  # def get_users_connection(_, _, _), do: {:error, :unauthorized}

  ## SIGN UP MUTATION

  def sign_up(_, %{input: %{event_id: event_id}}, %{context: %{current_user: current_user}}) do
    %{event_id: event_id, user_id: current_user.id}
    |> Events.create_event_users()
    |> handle_sign_up()
  end

  def sign_up(_, _, _), do: {:error, :unauthorized}

  def handle_sign_up({:ok, _}), do: {:ok, %{success: true}}

  def handle_sign_up({:error, %Ecto.Changeset{action: :insert, errors: errors}}) do
    case errors[:user_id] do
      {"has already been taken", _} ->
        {:ok, %{success: true, already_signed_up: true}}

      _ ->
        {:ok, %{success: false}}
    end
  end

  def handle_sign_up(_), do: {:ok, %{success: false}}

  ## CANCEL SIGN UP MUTATION

  def cancel_sign_up(_, %{input: %{event_id: event_id}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Events.EventUsers
    |> Repo.get_by(%{event_id: event_id, user_id: user_id})
    |> handle_cancel_sign_up()
  end

  def cancel_sign_up(_, _, _), do: {:error, :unauthorized}

  def handle_cancel_sign_up(nil) do
    {:error, %{success: false, already_signed_up: false}}
  end

  def handle_cancel_sign_up(event_user = %Events.EventUsers{}) do
    event_user
    |> Events.delete_event_users()
    |> case do
      {:ok, _} -> {:ok, %{success: true}}
      _ -> {:ok, %{success: false}}
    end
  end

  ## GET NODE BY ID

  def get_node(_, %{id: id}, _ctx) do
    {:ok, Lknvball.Events.get_event!(id)}
    # TODO: handle error
  end

  def get_node(_, _, _) do
    {:error, "expected id for event node"}
  end

  ## CREATE EVENT MUTATION

  def create_event(_, %{input: input}, _) do
    Lknvball.Events.create_event(input)
    |> case do
      {:ok, event} -> {:ok, %{success: true, edge: %{node: event}}} # TODO: this "edge" doesn't have a cursor.  Is it valid?
      _ -> {:ok, %{success: false}}
    end
  end

  def create_event(_, _, _) do
    {:error, "expected input for event creation"}
  end

  ## UPDATE EVENT MUTATION

  def update_event(_, %{input: %{id: id} = input}, _) do
    Lknvball.Events.get_event!(id)
    |> Lknvball.Events.update_event(input)
    |> case do
      {:ok, event} -> {:ok, %{success: true, edge: %{node: event}}}
      _ -> {:ok, success: false}
    end
  end

  def update_event(_, _, _) do
    {:error, "invalid input"}
  end
end
