defmodule SpotifyReDiscoverer.SpotifyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpotifyReDiscoverer.Spotify` context.
  """
  alias SpotifyReDiscoverer.AccountsFixtures

  @doc """
  Generate a credentials.
  """
  def credentials_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    {:ok, credentials} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token",
        refresh_token: "some refresh_token",
        user_id: user.id,
        expires_in: 3600,
        scope: "some-scope another-scope",
        token_type: "Bearer"
      })
      |> SpotifyReDiscoverer.Spotify.create_credentials()

    credentials
  end

  @doc """
  Generate a spotify_user.
  """
  def spotify_user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        spotify_id: "some spotify_id"
      })
      |> SpotifyReDiscoverer.Spotify.create_user()

    user
  end
end
