defmodule SpotifyReDiscoverer.Spotify.Client do
  @base_url "accounts.spotify.com"

  def authenticate do
    authorize_url() |> Req.get!() |> Map.get(:body)
  end

  def exchange_code_for_tokens(code) do
    token_url() |> Req.post!(form: token_form_data(code), headers: token_headers())
  end

  def secure_random_string do
    :crypto.strong_rand_bytes(16) |> Base.encode64() |> binary_part(0, 16)
  end

  def authorize_url do
    %URI{
      scheme: "https",
      host: @base_url,
      path: "/authorize",
      port: 443,
      query:
        URI.encode_query(%{
          client_id: client_id(),
          redirect_uri: redirect_uri(),
          response_type: "code",
          state: secure_random_string(),
          scope: Enum.join(scopes(), " ")
        })
    }
    |> URI.to_string()
  end

  def token_url do
    %URI{
      scheme: "https",
      host: @base_url,
      path: "/api/token"
    }
    |> URI.to_string()
  end

  def token_form_data(code) do
    %{
      code: code,
      redirect_uri: redirect_uri(),
      grant_type: "authorization_code"
    }
  end

  def token_headers do
    %{
      "Authorization" => "Basic #{encoded_credentials()}"
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

  defp client_id, do: Application.get_env(:spotify_re_discoverer, :spotify)[:client_id]
  defp client_secret, do: Application.get_env(:spotify_re_discoverer, :spotify)[:client_secret]

  defp encoded_credentials, do: Base.encode64("#{client_id()}:#{client_secret()}")

  defp redirect_uri, do: Application.get_env(:spotify_re_discoverer, :spotify)[:redirect_uri]
end
