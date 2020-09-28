defmodule LknvballWeb.Plug.AbsintheContext do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn
  import GlobalHelpers, only: [snake_case: 1]

  def init(opts), do: opts

  # this is garbage, I shouldnt have to destructure sub
  # and also get_req_header should be handled by Guardian.current_resource
  def call(%{remote_ip: remote_ip} = conn, _) do
    with [token] <- get_req_header(conn, "authorization"),
         {:ok, %{"sub" => user}} <- LknvballWeb.Guardian.decode_and_verify(token) do
      put_private(conn, :absinthe, %{
        context: %{current_user: snake_case(user), remote_ip: remote_ip}
      })
    else
      _ -> put_private(conn, :absinthe, %{context: %{remote_ip: remote_ip}})
    end
  end
end
