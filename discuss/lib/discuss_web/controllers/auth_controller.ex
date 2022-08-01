defmodule DiscussWeb.AuthController do
    use DiscussWeb, :controller
    plug Ueberauth

    alias DiscussWeb.User

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
        #IO.puts "+++++++++ beginning of assigns +++++++++++++++"
        #IO.inspect(conn.assigns)
        #IO.puts "+++++++++++ end of assigns, beginning of params +++++++++++++"
        #IO.inspect(params)
        #IO.puts "+++++++++++ end of params +++++++++++++"
        IO.puts "+++++++++ beginning of params +++++++++++++++"
        # %{"code" => code, "provider" => provider} = params
        #IO.puts "code is: [#{code}], and provider is: [#{provider}]"
        #IO.inspect(auth)
        #IO.puts "+++++++++ beginning of params +++++++++++++++"
        user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider}
        changeset = User.changeset(%User{}, user_params)

        signin(conn, changeset, auth.info.name)

    end

    def signout(conn, _params) do 
        conn 
        |> configure_session(drop: true) # drop the session/cookie altogehter, or just user id: put_session(:user_id, nil)
        |> redirect(to: topic_path(conn, :index))
    end 

    defp signin(conn, changeset, username) do
        case insert_or_update_users(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "Welcome back: #{username}!")
                |> put_session(:user_id, user.id) # session essentially is just cookie that is encrypted for security reason.
                |> redirect(to: topic_path(conn, :index))
            {:error, reason} ->
                IO.inspect(changeset)
                conn
                |> put_flash(:error, "Error signing in: #{reason}")
                |> redirect(to: topic_path(conn, :index))
        end
    end

    defp insert_or_update_users(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil -> 
                Repo.insert(changeset)
            user ->
                {:ok, user}
        end
    end


end
