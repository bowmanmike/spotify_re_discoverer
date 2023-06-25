defmodule SpotifyReDiscoverer.Spotify.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spotify_users" do
    field :spotify_id, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:spotify_id])
    |> validate_required([:spotify_id])
  end
end
