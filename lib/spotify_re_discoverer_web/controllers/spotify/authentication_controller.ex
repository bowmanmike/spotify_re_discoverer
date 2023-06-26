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

  def authorize(conn, %{"code" => code} = params) do
    # params contains `code` and `state`
    # `state` should match the random string sent to spotify initially
    #    -> should we save it in the DB? Or like use an actor, since its ephemeral
    # `code` needs to go back to spotify to request the tokens, so maybe from here
    #        I don't need to go back to the live view

    # TODO: this is temporary
    Spotify.list_spotify_credentials() |> Enum.map(&Spotify.delete_credentials/1)
    IO.inspect(params)

    with :ok <- check_state(params["state"]),
         %{body: response_body} <- Client.exchange_code_for_tokens(code),
         credential_params <-
           Map.merge(response_body, %{"user_id" => conn.assigns.current_user.id}),
         {:ok, _credentials} <- Spotify.create_credentials(credential_params) do
      conn
      |> put_flash(:info, "Authentication Successful!")
      |> redirect(to: ~p"/")
    else
      err -> error(conn, Map.merge(params, %{error: err}))
    end
  end

  def authenticated(conn, params) do
    # this is never called
    IO.inspect(params, label: :authenticated)

    conn
    |> put_flash(:info, "Something is happening...")
    |> redirect(to: ~p"/")
  end

  def error(conn, params) do
    Logger.warning("authentication failed with response: #{IO.inspect(params)}")

    conn
    |> put_flash(:error, "Something went wrong, please try again")
    |> redirect(to: ~p"/")
  end

  defp check_state(nil), do: :invalid_state
  defp check_state(state) when is_binary(state), do: :ok
end
