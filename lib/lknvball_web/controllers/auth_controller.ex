defmodule LknvballWeb.AuthController do
  use LknvballWeb, :controller
  alias Lknvball.Accounts
  alias Ueberauth
  require Logger

  plug Ueberauth

  def callback(conn, _params) do
    with {:ok, oauth_response} <- get_oauth_params(conn),
         {:ok, frontend_url} <- get_frontend_url(),
         {:ok, token} <- Accounts.register(oauth_response) do
      conn |> redirect(external: "#{frontend_url}/oauth?authorization=#{token}")
    else
      {:error, err} ->
        Logger.warn(err)
        Plug.Conn.put_status(conn, 500)

      _err ->
        Plug.Conn.put_status(conn, :not_found) |> redirect(to: "/")
    end
  end

  defp get_frontend_url() do
    {:ok, frontend_url: url} = Application.fetch_env(:lknvball, :frontend)
    {:ok, url} |> IO.inspect(label: "url")
  end

  defp get_oauth_params(%{
         assigns: %{
           ueberauth_auth: %{
             info: %{
               email: email,
               image: image
             },
             provider: provider,
             uid: uid
           }
         }
       }) do
    {:ok, %{email: email, provider: provider, uid: uid, image: image}}
  end

  defp get_oauth_params(conn), do: Logger.warn("oauth2 failed from #{conn}")

  # defp scrub_oauth2(e), do: IO.inspect(e)
end
