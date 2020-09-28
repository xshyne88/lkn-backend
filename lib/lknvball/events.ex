defmodule Lknvball.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Lknvball.Repo

  alias Lknvball.Events.Event

  def list_participants(%{id: id} = related) do
    query = from e in Lknvball.Events.EventUsers, where: e.event_id == ^id

    query
  end

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  def list_events(_related, _args) do
    Event
  end

  def list_events_by_date(_, %{days: days}) do
    period = "day"

    from(e in Event,
      where: e.start_time > fragment("CURRENT_DATE - ('1 ' || ?)::interval * ?", ^period, ^days)
    )
  end

  def list_future_events(_, _) do
    from(e in Event,
      where: e.start_time > fragment("CURRENT_DATE")
    )
  end

  def list_past_events(_, _) do
    from(e in Event,
      where: e.start_time < fragment("CURRENT_DATE")
    )
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias Lknvball.Events.EventUsers

  @doc """
  Returns the list of event_users.

  ## Examples

      iex> list_event_users()
      [%EventUsers{}, ...]

  """
  def list_event_users do
    Repo.all(EventUsers)
  end

  @doc """
  Gets a single event_users.

  Raises `Ecto.NoResultsError` if the Event users does not exist.

  ## Examples

      iex> get_event_users!(123)
      %EventUsers{}

      iex> get_event_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_users!(id), do: Repo.get!(EventUsers, id)

  @doc """
  Creates a event_users.

  ## Examples

      iex> create_event_users(%{field: value})
      {:ok, %EventUsers{}}

      iex> create_event_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_users(attrs \\ %{}) do
    %EventUsers{}
    |> EventUsers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_users.

  ## Examples

      iex> update_event_users(event_users, %{field: new_value})
      {:ok, %EventUsers{}}

      iex> update_event_users(event_users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_users(%EventUsers{} = event_users, attrs) do
    event_users
    |> EventUsers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event_users.

  ## Examples

      iex> delete_event_users(event_users)
      {:ok, %EventUsers{}}

      iex> delete_event_users(event_users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_users(%EventUsers{} = event_users) do
    Repo.delete(event_users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_users changes.

  ## Examples

      iex> change_event_users(event_users)
      %Ecto.Changeset{data: %EventUsers{}}

  """
  def change_event_users(%EventUsers{} = event_users, attrs \\ %{}) do
    EventUsers.changeset(event_users, attrs)
  end
end
