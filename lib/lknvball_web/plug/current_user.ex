defmodule LknvballWeb.Plug.AbsintheContext do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(%{remote_ip: remote_ip} = conn, _) do
    with [token] <- get_req_header(conn, "authorization"),
    {:ok, user} <- LknvballWeb.Guardian.decode_and_verify(token) do
      put_private(conn, :absinthe, %{context: %{current_user: user, remote_ip: remote_ip}})
    else
      _ -> put_private(conn, :absinthe, %{context: %{remote_ip: remote_ip}})
    end
  end
end
