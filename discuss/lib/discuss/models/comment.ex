defmodule Discuss.Comment do
  use DiscussWeb, :model

  # if we are planning to send a list of comments fetched from DB to the remote client in browser,
  # then this line is needed to tell the encode to only try to put content field into json data, ignoring all other phoenix related fields
  # otherwise, when this list gets send down it would fail to be json'ized!
   @derive {Jason.Encoder, only: [:content, :user]}

    schema "comments" do
        field :content, :string
        belongs_to :user, Discuss.User
        belongs_to :topic, Discuss.Topic
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:content])
        |> validate_required([:content])
    end
end
