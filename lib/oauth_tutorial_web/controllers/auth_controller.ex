defmodule OauthTutorialWeb.AuthController do
  use OauthTutorialWeb, :controller
  plug Ueberauth
  alias OauthTutorial.Accounts.User
  alias OauthTutorial.Repo
  # import Joken

  require Logger
  @jwt_secret "gjJg8aSLYjnb7Jl0OHjlpQNZhZlveVnMvlgKJ1JO7dcC+J13LQtDTqD4VqYikFKt"

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_data = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    case findOrCreateUser(user_data) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to OAuth Tutorial!")
        # |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def options(conn, _params) do
    conn
    |> put_resp_header("allow", "OPTIONS, POST")
    |> send_resp(204, "Here")
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)

    if user && Pbkdf2.verify_pass(password, user.password) do
      # token = generate_token(user.id)
      # Logger.info("User found: #{inspect(token)}")

      conn
      # |> put_resp_content_type("application/json")
      # |> send_resp(200, Jason.encode!(%{token: token}))
      # |> put_session(:user_id, user.id)
      # |> put_flash(:info, "Logged In!")
      |> redirect(to: "/dashboard")
    else
      conn
      |> put_flash(:error, "Invalid email or password")
      |> redirect(to: "/login")
    end
  end

  def sign_up(conn, %{"username" => username, "email" => email, "password" => password}) do
    require Logger
    hashed_password = Pbkdf2.hash_pwd_salt(password)

    user_params = %{
      "username" => username,
      "email" => email,
      "password" => hashed_password
    }

    case findOrCreateUser(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to OAuth Tutorial!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    # case Accounts.create_user(user_params) do
    #   {:ok, user} ->
    #     json(conn, %{status: "success", message: "User signed up successfully", user: user})

    #   {:error, changeset} ->
    #     json(conn, %{status: "error", message: "Sign up failed", errors: changeset})
    end
  end

  # defp generate_token(user_id) do
  #   # Define the claims for the token
  #   claims = %{"user_id" => user_id}

  #   # Create a new Joken token
  #   token = Joken.Token.new()
  #   |> Joken.with_claims(claims)
  #   |> Joken.with_signer(Joken.Signer.create("HS256", @jwt_secret))

  #   # Sign the token and get the compact representation
  #   Joken.Token.sign(token)
  #   |> Joken.Token.get_compact()
  # end

  defp findOrCreateUser(user_data) do
    require Logger
    changeset = User.changeset(%User{}, user_data)

    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        IO.puts("User not found, creating new one")
        Repo.insert(changeset)
      user -> {:ok, user}
    end
  end

end
