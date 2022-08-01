defmodule DiscussWeb.Plugs.SetUser do
    import Plug.Conn # to give us a bunch of helper funcs to work with conn
    import Phoenix.Controller # provide us get_session() 

    alias Discuss.Repo
    alias DiscussWeb.User

    def init(_params ) do
    end

    def call(conn, _params) do
        user_id = get_session(conn, :user_id)
        cond do
            user = user_id && Repo.get(User, user_id) ->
                assign(conn, :user, user)
            true ->
                assign(conn, :user, nil)
        end

    end
end
