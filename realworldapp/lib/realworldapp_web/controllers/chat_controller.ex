defmodule RealworldappWeb.ChatController do
    use RealworldappWeb, :controller
    
    def index(conn, _param) do
        conn
        |> assign(:randomvar, "random greetings")
        |> put_flash(:info, "welcome to the chat room!")
        |> render("index.html", var: "a random value", var2: "another random value")
    end

end