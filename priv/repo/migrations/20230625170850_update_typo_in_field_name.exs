defmodule SpotifyReDiscoverer.Repo.Migrations.UpdateTypoInFieldName do
  use Ecto.Migration

  def change do
    alter table(:spotify_credentials) do
      remove :expires
      add :expires_in, :integer, null: false
    end
  end
end
