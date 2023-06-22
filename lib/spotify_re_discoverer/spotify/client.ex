defmodule SpotifyReDiscoverer.Spotify.Client do
  @base_url "accounts.spotify.com"

  def authenticate do
    Req.get(authorize_url())
  end

  def secure_random_string do
    :crypto.strong_rand_bytes(16) |> Base.encode64() |> binary_part(0, 16)
  end

  def authorize_url do
    # require IEx
    # IEx.pry()

    %URI{
      scheme: "https",
      host: @base_url,
      path: "/authorize",
      port: 443,
      query:
        URI.encode_query(%{
          client_id: client_id(),
          redirect_url: "http://localhost:4000/authorize",
          response_type: "code",
          state: secure_random_string(),
          scopes: Enum.join(scopes(), " ")
        })
    }
  end

  def scopes do
    [
      "playlist-modify-private",
      "playlist-modify-public",
      "playlist-modify-public",
      "playlist-modify-private",
      "user-top-read",
      "user-read-recently-played",
      "user-library-read"
    ]
  end

  def client_id, do: Application.get_env(:spotify_re_discoverer, :spotify)[:client_id]
  def client_secret, do: Application.get_env(:spotify_re_discoverer, :spotify)[:client_secret]
end
