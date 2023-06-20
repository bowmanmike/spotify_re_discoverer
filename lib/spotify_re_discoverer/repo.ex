defmodule SpotifyReDiscoverer.Repo do
  use Ecto.Repo,
    otp_app: :spotify_re_discoverer,
    adapter: Ecto.Adapters.Postgres
end
