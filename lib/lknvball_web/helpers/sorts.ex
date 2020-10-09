defmodule LknvballWeb.Helpers.Sorts do
  import Ecto.Query

  @doc """
  Applies provided sorts to an ecto query using the order_by function.
  Sort format should be {field_name: :sort_direction} where :sort_direction
  is defined in the schema enums.
  """
  def apply_to_query(query, %{sort_by: sort_by}) do
    # TODO: Make sorts order safe

    order_by_list = create_order_by_list(sort_by)

    query
    |> order_by(^order_by_list)
  end

  def apply_to_query(query, _) do
    query
  end

  defp create_order_by_list(sort_by_field_map) when is_map(sort_by_field_map) do
    sort_by_field_map
    # List will be sorted alphabetically by the key
    |> Enum.to_list()
    |> Enum.map(&flip_tuple/1)
  end

  defp flip_tuple({a, b}) do
    {b, a}
  end
end
