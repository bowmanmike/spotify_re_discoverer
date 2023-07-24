defmodule SpotifyReDiscoverer.Spotify do
  @moduledoc """
  The Spotify context.
  """

  import Ecto.Query, warn: false

  alias SpotifyReDiscoverer.Accounts
  alias SpotifyReDiscoverer.Repo

  alias SpotifyReDiscoverer.Spotify.Credentials

  @doc """
  Returns the list of spotify_credentials.

  ## Examples

      iex> list_spotify_credentials()
      [%Credentials{}, ...]

  """
  def list_spotify_credentials do
    Repo.all(Credentials)
  end

  @doc """
  Gets a single credentials.

  Raises `Ecto.NoResultsError` if the Credentials does not exist.

  ## Examples

      iex> get_credentials!(123)
      %Credentials{}

      iex> get_credentials!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credentials!(id), do: Repo.get!(Credentials, id)

  @doc """
  Creates a credentials.

  ## Examples

      iex> create_credentials(%{field: value})
      {:ok, %Credentials{}}

      iex> create_credentials(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credentials(attrs \\ %{}) do
    %Credentials{}
    |> Credentials.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credentials.

  ## Examples

      iex> update_credentials(credentials, %{field: new_value})
      {:ok, %Credentials{}}

      iex> update_credentials(credentials, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credentials(%Credentials{} = credentials, attrs) do
    credentials
    |> Credentials.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a credentials.

  ## Examples

      iex> delete_credentials(credentials)
      {:ok, %Credentials{}}

      iex> delete_credentials(credentials)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credentials(%Credentials{} = credentials) do
    Repo.delete(credentials)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credentials changes.

  ## Examples

      iex> change_credentials(credentials)
      %Ecto.Changeset{data: %Credentials{}}

  """
  def change_credentials(%Credentials{} = credentials, attrs \\ %{}) do
    Credentials.changeset(credentials, attrs)
  end

  alias SpotifyReDiscoverer.Spotify.User

  @doc """
  Returns the list of spotify_users.

  ## Examples

      iex> list_spotify_users()
      [%User{}, ...]

  """
  def list_spotify_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def preload_credentials(%Accounts.User{} = user), do: Repo.preload(user, :spotify_credentials)
end
