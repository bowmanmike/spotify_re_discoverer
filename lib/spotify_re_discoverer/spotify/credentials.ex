defmodule SpotifyReDiscoverer.Spotify.Credentials do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spotify_credentials" do
    field :access_token, :string
    field :refresh_token, :string
    field :expires_in, :integer
    field :scope, :string
    field :token_type, :string

    belongs_to(:user, SpotifyReDiscoverer.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(credentials, attrs) do
    credentials
    |> cast(attrs, [:access_token, :refresh_token, :user_id, :expires_in, :scope, :token_type])
    |> validate_required([
      :access_token,
      :refresh_token,
      :user_id,
      :expires_in,
      :scope,
      :token_type
    ])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id)
  end
end
