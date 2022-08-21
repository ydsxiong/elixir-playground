defmodule Discuss.User do
    use Discuss, :model
    
    @derive {Jason.Encoder, only: [:email]}

    schema "users_elixir" do
        field :email, :string
        field :provider, :string
        field :token, :string
        has_many :topics, Discuss.Topic
        has_many :comments, Discuss.Comment
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email, :provider, :token])
        |> validate_required([:email, :provider, :token])
    end
end
