defmodule LknvballWeb.Role do
  @behaviour Absinthe.Middleware

  def call(resolution, role) do
    validate_role(resolution, role)
  end

  def validate_role(%{context: %{current_user: %{admin: true}}} = resolution, :admin) do
    resolution
  end

  def validate_role(resolution, _) do
    resolution
    |> Absinthe.Resolution.put_result({:error, "Action not permitted"})
  end
end
