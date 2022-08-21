defmodule RealworldappWeb.GreetingsController do
    use RealworldappWeb, :controller
    
    def index(conn, _param) do
        conn
        # |> put_resp_content_type("text/plain")
        |> assign(:randomvar, "random greetings")
        |> put_flash(:info, "welcome back!")
        |> render("index.html", var: "a random value", var2: "another random value")
    end

    def show(conn, %{"message" => message}) do
        conn
        |> render("show.html", message: message)
    end
end