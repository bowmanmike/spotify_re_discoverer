defmodule SpotifyReDiscovererWeb.Spotify.AuthenticationController do
  use SpotifyReDiscovererWeb, :controller

  alias SpotifyReDiscoverer.Spotify.Client
  alias SpotifyReDiscoverer.Spotify

  require Logger

  def callback(conn, params) do
    case params do
      %{"code" => _code, "state" => _state} = params -> authorize(conn, params)
      %{"access_token" => _token} = params -> authenticated(conn, params)
      params -> error(conn, params)
    end
  end

  def authorize(conn, %{"code" => code, "state" => state} = params) do
    IO.inspect(params, label: :code_and_state_params)
    # params contains `code` and `state`
    # `state` should match the random string sent to spotify initially
    #    -> should we save it in the DB? Or like use an actor, since its ephemeral
    # `code` needs to go back to spotify to request the tokens, so maybe from here
    #        I don't need to go back to the live view

    resp = Client.exchange_code_for_tokens(code)
    IO.inspect(resp, label: :spotify_auth_tokens)

    r =
      Spotify.create_credentials(
        Map.merge(resp.body, %{"user_id" => conn.assigns.current_user.id})
      )

    conn
    |> put_flash(:info, "Authentication Successful!")
    |> redirect(to: ~p"/")
  end

  def authenticated(conn, params) do
    IO.inspect(params, label: :authenticated)

    conn
    |> put_flash(:info, "Something is happening...")
    |> redirect(to: ~p"/")
  end

  def error(conn, params) do
    Logger.warning("authentication failed with response: #{IO.inspect(params)}")

    conn
    |> put_flash(:error, "Something went wrong")
    |> redirect(to: ~p"/")
  end
end
