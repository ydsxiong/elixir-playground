defmodule DiscussWeb.Plugs.RequireAuth do
    import Plug.Conn
    import Phoenix.Controller

    alias DiscussWeb.Router.Helpers

    def init(_params) do
    end

    def call(conn, _params) do
        if conn.assigns[:user] do
            conn # nothing further to do
        else
            conn
            |> put_flash(:error, "You have to be logged in.")
            |> redirect(to: Helpers.topic_path(conn, :index))
            |> halt() # means we are completely done with this conn, so take no furhter action, and just return the conn.
        end
    end

end
