# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lknvball.Repo.insert!(%Lknvball.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
seconds_in_day = 86_400

tomorrow = DateTime.add(DateTime.utc_now(), seconds_in_day, :seconds)
dayafter = DateTime.add(DateTime.utc_now(), seconds_in_day * 2, :seconds)
dayafterafter = DateTime.add(DateTime.utc_now(), seconds_in_day * 3, :seconds)

Lknvball.Events.create_event(%{
  name: "Blind Draw Thursday",
  cost: 20,
  start_time: DateTime.utc_now()
})

Lknvball.Events.create_event(%{name: "Blind Draw Friday", cost: 20, start_time: tomorrow})
Lknvball.Events.create_event(%{name: "Mix n Match Saturday", cost: 20, start_time: dayafter})
Lknvball.Events.create_event(%{name: "Blind Draw Saturday", cost: 20, start_time: dayafterafter})

Lknvball.Accounts.create_user(%{name: "User 1", email: "user1@gmail.com", image: "none"})
Lknvball.Accounts.create_user(%{name: "User 2", email: "user2@gmail.com", image: "none"})
