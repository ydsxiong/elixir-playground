defmodule RealworldappWeb.PageController do
  use RealworldappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
