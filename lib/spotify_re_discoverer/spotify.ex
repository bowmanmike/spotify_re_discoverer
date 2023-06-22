defmodule SpotifyReDiscoverer.Spotify do
  @moduledoc """
  The Spotify context.
  """

  import Ecto.Query, warn: false
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
end
