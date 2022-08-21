defmodule Realworldapp.Repo do
  use Ecto.Repo,
    otp_app: :realworldapp,
    adapter: Ecto.Adapters.MyXQL
end
