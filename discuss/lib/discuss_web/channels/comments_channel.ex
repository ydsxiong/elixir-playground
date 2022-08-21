defmodule DiscussWeb.CommentsChannel do
    use DiscussWeb, :channel
    alias Discuss.{Topic, Comment}

    # this is called whenever js client join()
    # 1st arg - name is the channel name the client joined in with: comments:6
    def join("comments:" <> topic_id, _params, socket) do
     
        topic = Topic
                |> Repo.get(String.to_integer(topic_id))
                |> Repo.preload(comments: [:user])
     
        {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    end

    def handle_in(name, %{"content" => content}, socket) do
        topic = socket.assigns.topic
        user_id = socket.assigns.user_id

        changeset = topic
        |> build_assoc(:comments, user_id: user_id) # this creates/builds a new comment struct with associated user id and topic id without preloading them.
        #|> IO.inspect
        |> Comment.changeset(%{content: content}) # this merges the new struct with the new content to be saved.
        #|> IO.inspect

        case Repo.insert(changeset) do
            {:ok, comment} -> 
                comment = comment
                #|> IO.inspect
                |> Repo.preload(:user) # this preloads the user data into the chosen comment.
                #|> IO.inspect
                # this preloads is needed because it's explicitly specified in the comment model that user should be loaded for the Jason.Encoder!
                broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
        
    end
end
