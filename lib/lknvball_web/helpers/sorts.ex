defmodule LknvballWeb.Helpers.Sorts do
  import Ecto.Query

  def apply_to_query(query, %{sort_by: sort_by}) do
    order_by_list = create_order_by_list(sort_by)

    query
    |> order_by(^order_by_list)
  end

  def apply_to_query(query, _) do
    query
  end

  defp create_order_by_list(sort_by_field_map) do # todo: add a guard here?
    sort_by_field_map
    |> Enum.to_list
    |> Enum.map(&flip_tuple/1)
    # |> Enum.map(&convert_value_to_direction/1)
  end

  defp flip_tuple({a, b}) do
    {b, a}
  end
end