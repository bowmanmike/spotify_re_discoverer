defmodule SpotifyReDiscoverer.Spotify.Client do
  def client_id, do: Application.get_env(:spotify_re_discoverer, :spotify)[:client_id]
  def client_secret, do: Application.get_env(:spotify_re_discoverer, :spotify)[:client_secret]
end
