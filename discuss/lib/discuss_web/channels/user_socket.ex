defmodule DiscussWeb.UserSocket do
    use Phoenix.Socket

    channel "comments:*", DiscussWeb.CommentsChannel
    # this is much the same as defining a http route: get "/comments/:id", CommentController, :handle_in

    transport :websocket, Phoenix.Transports.WebSocket

   # whenever js client joins, this connect would kick off
    def connect(%{"token" => token}, socket) do
        #IO.puts("++++++++++++++++")
        #IO.inspect(token)
        #IO.puts("++++++++++++++++")
        case Phoenix.Token.verify(socket, "someRandomKey", token) do 
            {:ok, user_id} ->
              {:ok, assign(socket, :user_id, user_id)}
            {:error, _error} ->
              :error
        end 
    end 

    def id(_socket), do: nil
end