defmodule LknvballWeb.Authentication do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    authenticate(resolution)
  end

  def authenticate(%{context: %{current_user: _current_user}} = resolution) do
    resolution
  end

  def authenticate(resolution) do
    IO.inspect(resolution.context)

    resolution
    |> Absinthe.Resolution.put_result({:error, "unauthenticated"})
  end
end
