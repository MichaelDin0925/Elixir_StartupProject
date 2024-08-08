defmodule OauthTutorial.Accounts do
  alias OauthTutorial.Repo
  alias OauthTutorial.Accounts.User

  def create_user(attrs \\ %{}) do
    require Logger
    # hashed_password = Bcrypt.hash_pwd_salt(password)
    Logger.info  "Logging this create user!"
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
