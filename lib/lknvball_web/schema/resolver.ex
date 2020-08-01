defmodule Lknvball.NodeType do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      def resolve_node_type(_, _), do: nil
    end
  end
end
