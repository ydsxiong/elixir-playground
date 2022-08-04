defmodule DiscussWeb.Topic do
    use DiscussWeb, :model
    
    # step 1 create a schema to let/help phoenix know what to expect from db
    schema "topics" do
        field :title, :string
        belongs_to :user, DiscussWeb.User
        has_many :comments, DiscussWeb.Comment
    end

    # step 2 add some validation rule for phoenix to know what data to expect from UI
    # struct represents record we want to save to db, it's what the current data is from the UI
    # param reps how we want to save it, it's what we expect the data to become before being saved to db
    # cast() produces a changeset of data to get from what data currently is, to what the data needs to be
    # the struct is not what's saved, but the result struct produced by changeset():
    #
    #Ecto.Changeset<
    #action: nil,
    #changes: %{title: "Great Elixir"},
    #errors: [],
    #data: #DiscussWeb.Topic<>,
    #valid?: true
    #>
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:title])
        |> validate_required([:title])
    end

end
