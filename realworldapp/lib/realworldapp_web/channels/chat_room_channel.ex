defmodule RealworldappWeb.ChatRoomChannel do
  use RealworldappWeb, :channel

  @impl true
  def join("chat_room:lobby", payload, socket) do
    #IO.puts("+++++++++ socket joineed  +++++++")
    #IO.inspect payload
    #IO.puts("++++++++++++++++")
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  @impl true
  def handle_in("new_msg", %{"message" => message}, socket) do
    broadcast! socket, "new_msg", %{"message" => message}
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
