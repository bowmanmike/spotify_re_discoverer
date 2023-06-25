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
        expires_in: 3600,
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

  describe "spotify_users" do
    alias SpotifyReDiscoverer.Spotify.User

    import SpotifyReDiscoverer.SpotifyFixtures

    @invalid_attrs %{spotify_id: nil}

    test "list_spotify_users/0 returns all spotify_users" do
      user = user_fixture()
      assert Spotify.list_spotify_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Spotify.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{spotify_id: "some spotify_id"}

      assert {:ok, %User{} = user} = Spotify.create_user(valid_attrs)
      assert user.spotify_id == "some spotify_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spotify.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{spotify_id: "some updated spotify_id"}

      assert {:ok, %User{} = user} = Spotify.update_user(user, update_attrs)
      assert user.spotify_id == "some updated spotify_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Spotify.update_user(user, @invalid_attrs)
      assert user == Spotify.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Spotify.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Spotify.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Spotify.change_user(user)
    end
  end
end
