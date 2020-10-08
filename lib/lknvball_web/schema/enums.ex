defmodule LknvballWeb.Schema.Enums do
  use Absinthe.Schema.Notation

  enum :sort_direction do
    description "Sort direction"

    value :asc
    value :desc
  end
end