defmodule SpotifyReDiscoverer.SpotifyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpotifyReDiscoverer.Spotify` context.
  """

  @doc """
  Generate a credentials.
  """
  def credentials_fixture(attrs \\ %{}) do
    {:ok, credentials} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token",
        refresh_token: "some refresh_token"
      })
      |> SpotifyReDiscoverer.Spotify.create_credentials()

    credentials
  end
end
