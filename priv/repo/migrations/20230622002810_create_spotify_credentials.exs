defmodule SpotifyReDiscoverer.Repo.Migrations.CreateSpotifyCredentials do
  use Ecto.Migration

  def change do
    create table(:spotify_credentials, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :access_token, :string
      add :refresh_token, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:spotify_credentials, [:user_id])
  end
end
