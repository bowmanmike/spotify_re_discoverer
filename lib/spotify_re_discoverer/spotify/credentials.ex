defmodule SpotifyReDiscoverer.Spotify.Credentials do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spotify_credentials" do
    field :access_token, :string
    field :refresh_token, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(credentials, attrs) do
    credentials
    |> cast(attrs, [:access_token, :refresh_token])
    |> validate_required([:access_token, :refresh_token, :user_id])
    |> unique_constraint(:user_id)
  end
end
