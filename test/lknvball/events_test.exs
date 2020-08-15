defmodule Lknvball.EventsTest do
  use Lknvball.DataCase

  alias Lknvball.Events

  describe "events" do
    alias Lknvball.Events.Event

    @valid_attrs %{cost: 42, image: "some image", name: "some name"}
    @update_attrs %{cost: 43, image: "some updated image", name: "some updated name"}
    @invalid_attrs %{cost: nil, image: nil, name: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.cost == 42
      assert event.image == "some image"
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.cost == 43
      assert event.image == "some updated image"
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "event_users" do
    alias Lknvball.Events.EventUsers

    @valid_attrs %{paid: true}
    @update_attrs %{paid: false}
    @invalid_attrs %{paid: nil}

    def event_users_fixture(attrs \\ %{}) do
      {:ok, event_users} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event_users()

      event_users
    end

    test "list_event_users/0 returns all event_users" do
      event_users = event_users_fixture()
      assert Events.list_event_users() == [event_users]
    end

    test "get_event_users!/1 returns the event_users with given id" do
      event_users = event_users_fixture()
      assert Events.get_event_users!(event_users.id) == event_users
    end

    test "create_event_users/1 with valid data creates a event_users" do
      assert {:ok, %EventUsers{} = event_users} = Events.create_event_users(@valid_attrs)
      assert event_users.paid == true
    end

    test "create_event_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event_users(@invalid_attrs)
    end

    test "update_event_users/2 with valid data updates the event_users" do
      event_users = event_users_fixture()
      assert {:ok, %EventUsers{} = event_users} = Events.update_event_users(event_users, @update_attrs)
      assert event_users.paid == false
    end

    test "update_event_users/2 with invalid data returns error changeset" do
      event_users = event_users_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event_users(event_users, @invalid_attrs)
      assert event_users == Events.get_event_users!(event_users.id)
    end

    test "delete_event_users/1 deletes the event_users" do
      event_users = event_users_fixture()
      assert {:ok, %EventUsers{}} = Events.delete_event_users(event_users)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event_users!(event_users.id) end
    end

    test "change_event_users/1 returns a event_users changeset" do
      event_users = event_users_fixture()
      assert %Ecto.Changeset{} = Events.change_event_users(event_users)
    end
  end
end
