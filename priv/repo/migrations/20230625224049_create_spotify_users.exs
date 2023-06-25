defmodule SpotifyReDiscoverer.Repo.Migrations.CreateSpotifyUsers do
  use Ecto.Migration

  def change do
    create table(:spotify_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :spotify_id, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:spotify_users, [:user_id])
  end
end
