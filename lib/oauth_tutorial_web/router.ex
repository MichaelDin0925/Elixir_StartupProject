defmodule OauthTutorialWeb.Router do
  use OauthTutorialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, {OauthTutorialWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OauthTutorial.Plugs.SetUser
  end

  pipeline :api do
    plug CORSPlug
    plug :fetch_session
    plug :fetch_flash
    plug :accepts, ["json"]
  end

  scope "/", OauthTutorialWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/todos", TodoController

  end

  scope "/", OauthTutorialWeb do
    pipe_through :browser

    # Add the following route
    resources "/checkout-session", CheckoutSessionController, only: [:create]
    get "/", PageController, :index
  end

  # API Routes
  scope "/api", OauthTutorialWeb do
    pipe_through :api
    require Logger
    Logger.info  "Logging this route!"

    options "/account/register", AuthController, :options
    post "/account/register", AuthController, :sign_up
    get "/account/register", AuthController, :options
    post "/account/login", AuthController, :login

    post "/checkout-product", CheckoutSessionController, :create
    # get "/account/login", AuthController, :options
  end

  scope "/auth", OauthTutorialWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # scope "/signup", OauthTutorialWeb do
  #   pipe_through :browser

  #   get "/", AuthController, :signup
  #   post "/", AuthController, :signup
  # end

  # Other scopes may use custom stacks.
  # scope "/api", OauthTutorialWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OauthTutorialWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
