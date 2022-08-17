defmodule DiscussWeb.TopicController do
    use DiscussWeb, :controller

    alias Discuss.Topic

   plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

   plug :check_topic_owner when action in [:edit, :update, :delete]


   def index(conn, _params) do
       #IO.puts "++++++++++++++++++++++++"
       #IO.inspect conn.assigns
       #IO.puts "++++++++++++++++++++++++"
      topics = Repo.all(Topic)
      render conn, "index.html", topics: topics
   end

   def show(conn, %{"id" => topic_id}) do
      topic = Repo.get!(Topic, topic_id)
      render conn, "show.html", topic: topic
   end

    def new(conn, _params) do
       #IO.puts "++++++++++++++++++++++++"
       #IO.inspect conn
       #IO.puts "++++++++++++++++++++++++"
       #IO.inspect params
       #IO.puts "++++++++++++++++++++++++"

        changeset = Topic.changeset(%Topic{})

        sum = 1 + 1

        render conn, "new.html", changeset: changeset, sum_test:  sum
    end

    # params = %{
     # "_csrf_token" => "CAUsGCoXNxw9LQsbdQ91RjE1P3oAaCBxl_ihEdBrxnch-VLkGDt2z-N5",
    # "topic" => %{"title" => "asdasd"}
     # }
    def create(conn, %{"topic" => topic}) do
       # changeset = Topic.changeset(%Topic{}, topic) # pass in an empty topic because we are creating a new one from scratch.
       changeset = conn.assigns.user
                     |> build_assoc(:topics)
                     |> Topic.changeset(topic)

       case Repo.insert(changeset) do 
         {:ok, _created} -> 
            conn
            |> put_flash(:info, "Topic Created")
            |> redirect(to: topic_path(conn, :index))
         {:error, changeset} -> 
            render conn, "new.html", changeset: changeset
       end

    end

    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end

   def update(conn, %{"id" => topic_id, "topic" => topic}) do
        old_topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic)

        case Repo.update(changeset) do
           {:ok, _updated} ->
                  conn
                  |> put_flash(:info, "Topic Updated")
                  |> redirect(to: topic_path(conn, :index))
           {:error, changeset} ->
                  render conn, "edit.html", changeset: changeset, topic: old_topic
        end
    end

   def delete(conn, %{"id" => topic_id}) do
         Repo.get!(Topic, topic_id)
         |> Repo.delete!

         conn
         |> put_flash(:info, "Topic deleted")
         |> redirect(to: topic_path(conn, :index))
   end

   def check_topic_owner(conn, _params) do
      %{params: %{"id" => topic_id}} = conn

      if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
         conn
      else 
         conn
         |> put_flash(:error, "You can not update or delete any topic that is not created by your")
         |> redirect(to: topic_path(conn, :index))
         |> halt()
      end
   end

end