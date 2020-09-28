defmodule LknvballWeb.Router do
  use LknvballWeb, :router
  require Absinthe.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :absinthe do
    # plug Guardian.Plug.Pipeline,
    #   module: LknvballWeb.Guardian,
    #   error_handler: LknvballWeb.AuthErrorHandler

    # plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    # plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    # # plug Guardian.Plug.EnsureAuthenticated
    # plug(Guardian.Plug.LoadResource, allow_blank: true)
    plug(LknvballWeb.Plug.AbsintheContext)
  end

  scope "/graphql" do
    pipe_through [:api, :absinthe]

    forward "/", Absinthe.Plug, schema: LknvballWeb.Schema
  end

  scope "/auth", LknvballWeb do
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    post "/logout", AuthController, :delete
  end

  scope "/graphiql" do
    pipe_through([:api, :absinthe])

    forward(
      "/",
      Absinthe.Plug.GraphiQL,
      schema: LknvballWeb.Schema,
      json_codec: Jason,
      interface: :advanced,
      socket: LknvballWeb.UserSocket
    )
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: LknvballWeb.Telemetry
    end
  end
end
