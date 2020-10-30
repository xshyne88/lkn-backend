defmodule LknvballWeb.Resolvers.Event do
  alias Absinthe.Relay.Connection
  alias Lknvball.Repo
  alias Lknvball.Events
  alias LknvballWeb.Helpers.Sorts

  ## GET EVENTS QUERY

  def get_events_connection(related, args, _ctx) do
    related
    |> Events.list_events(args)
    |> Sorts.apply_to_query(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def am_i_attending(%{id: event_id}, _, %{context: %{current_user: %{id: user_id}}}) do
    Events.EventUser
    |> Repo.get_by(%{event_id: event_id, user_id: user_id})
    |> case do
      nil -> {:ok, false}
      _ -> {:ok, true}
    end
  end

  def am_i_attending(_, _, _), do: {:error, :unknown}

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
    |> IO.inspect()
  end

  def get_participants_connection(_, _, _) do
    IO.warn("no id found for participants")
    {:error, :unknown}
  end

  ## SIGN UP MUTATION

  def sign_up(_, %{input: %{event_id: event_id}}, %{context: %{current_user: current_user}}) do
    %{event_id: event_id, user_id: current_user.id}
    |> Events.create_event_users()
    |> handle_sign_up()
  end

  def sign_up(_, _, _), do: {:error, :unknown}

  def handle_sign_up({:ok, event_user}) do
    event_user.event_id
    |> Events.get_event!()
    # TODO: handle failure
    |> (fn e -> {:ok, e} end).()
  end

  def handle_sign_up({:error, %Ecto.Changeset{action: :insert, errors: errors}}) do
    case errors[:user_id] do
      {"has already been taken", _} ->
        {:ok, nil}

      _ ->
        {:error, errors}
    end
  end

  def handle_sign_up(_), do: {:error, nil}

  ## CANCEL SIGN UP MUTATION

  def cancel_sign_up(_, %{input: %{event_id: event_id}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Events.EventUser
    |> Repo.get_by(%{event_id: event_id, user_id: user_id})
    |> handle_cancel_sign_up()
  end

  def cancel_sign_up(_, _, _), do: {:error, :unknown}

  def handle_cancel_sign_up(nil) do
    {:error, "You are not signed up for this event"}
  end

  def handle_cancel_sign_up(event_user = %Events.EventUser{}) do
    event_user
    |> Events.delete_event_users()
    |> case do
      {:ok, _} ->
        event_user.event_id
        |> Events.get_event!()
        # TODO: handle failure
        |> (fn e -> {:ok, e} end).()
    end
  end

  def handle_cancel_sign_up(_) do
    {:error, :unknown}
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
  end

  def create_event(_, _, _) do
    {:error, :unknown}
  end

  ## UPDATE EVENT MUTATION

  def update_event(_, %{input: %{id: id} = input}, _) do
    # TODO: handle errors here
    id
    |> Lknvball.Events.get_event!()
    |> Lknvball.Events.update_event(input)
  end

  def update_event(_, _, _) do
    {:error, :unknown}
  end
end
