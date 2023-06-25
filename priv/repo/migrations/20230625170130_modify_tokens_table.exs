defmodule SpotifyReDiscoverer.Repo.Migrations.ModifyTokensTable do
  use Ecto.Migration

  def change do
    alter table(:spotify_credentials) do
      modify :access_token, :text, null: false
      modify :refresh_token, :text, null: false
      add :expires_in, :integer, null: false
      add :scope, :string, null: false
      add :token_type, :string, null: false
    end
  end
end
