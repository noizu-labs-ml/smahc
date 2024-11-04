defmodule Smahca.Repo do
  use Ecto.Repo,
    otp_app: :smahca,
    adapter: Ecto.Adapters.Postgres
end
