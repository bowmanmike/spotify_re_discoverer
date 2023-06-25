defmodule SpotifyReDiscoverer.SpotifyTest do
  use SpotifyReDiscoverer.DataCase

  alias SpotifyReDiscoverer.Spotify

  describe "spotify_credentials" do
    alias SpotifyReDiscoverer.Spotify.Credentials

    import SpotifyReDiscoverer.{AccountsFixtures, SpotifyFixtures}

    @invalid_attrs %{access_token: nil, refresh_token: nil, user_id: nil}

    test "list_spotify_credentials/0 returns all spotify_credentials" do
      credentials = credentials_fixture()
      assert Spotify.list_spotify_credentials() == [credentials]
    end

    test "get_credentials!/1 returns the credentials with given id" do
      credentials = credentials_fixture()
      assert Spotify.get_credentials!(credentials.id) == credentials
    end

    test "create_credentials/1 with valid data creates a credentials" do
      user = user_fixture()

      valid_attrs = %{
        access_token: "some access_token",
        refresh_token: "some refresh_token",
        expires: 3600,
        scope: "some-scope another-scope",
        token_type: "Bearer",
        user_id: user.id
      }

      assert {:ok, %Credentials{} = credentials} = Spotify.create_credentials(valid_attrs)
      assert credentials.access_token == "some access_token"
      assert credentials.refresh_token == "some refresh_token"
    end

    test "create_credentials/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spotify.create_credentials(@invalid_attrs)
    end

    test "update_credentials/2 with valid data updates the credentials" do
      credentials = credentials_fixture()

      update_attrs = %{
        access_token: "some updated access_token",
        refresh_token: "some updated refresh_token"
      }

      assert {:ok, %Credentials{} = credentials} =
               Spotify.update_credentials(credentials, update_attrs)

      assert credentials.access_token == "some updated access_token"
      assert credentials.refresh_token == "some updated refresh_token"
    end

    test "update_credentials/2 with invalid data returns error changeset" do
      credentials = credentials_fixture()
      assert {:error, %Ecto.Changeset{}} = Spotify.update_credentials(credentials, @invalid_attrs)
      assert credentials == Spotify.get_credentials!(credentials.id)
    end

    test "delete_credentials/1 deletes the credentials" do
      credentials = credentials_fixture()
      assert {:ok, %Credentials{}} = Spotify.delete_credentials(credentials)
      assert_raise Ecto.NoResultsError, fn -> Spotify.get_credentials!(credentials.id) end
    end

    test "change_credentials/1 returns a credentials changeset" do
      credentials = credentials_fixture()
      assert %Ecto.Changeset{} = Spotify.change_credentials(credentials)
    end
  end
end
