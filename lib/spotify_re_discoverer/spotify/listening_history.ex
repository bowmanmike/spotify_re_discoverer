defmodule SpotifyReDiscoverer.Spotify.ListeningHistory do
  @moduledoc """
  Analyzes user listening history to identify forgotten favorites and patterns.
  """

  alias SpotifyReDiscoverer.Spotify.Client
  alias SpotifyReDiscoverer.Accounts.User

  @doc """
  Analyzes listening history to identify forgotten favorites.
  Returns tracks that appear in playlists but haven't been played recently.
  """
    def analyze_forgotten_favorites(%User{} = user) do
    # Get user's playlists
    playlists = Client.get_all_playlists(user)

    # Get recently played tracks (last 50)
    recently_played = Client.get_recently_played(user, limit: 50)

    # Extract track IDs from recently played
    recently_played_ids = extract_track_ids_from_history(recently_played)

    # Get all tracks from playlists
    playlist_tracks = extract_tracks_from_playlists(playlists, user)

    # Find tracks in playlists that haven't been played recently
    forgotten_tracks = find_forgotten_tracks(playlist_tracks, recently_played_ids)

    # Score and rank forgotten tracks
    score_forgotten_tracks(forgotten_tracks)
  end

  @doc """
  Gets listening history for a specific time period.
  """
  def get_listening_history(%User{} = user, opts \\ []) do
    Client.get_recently_played(user, opts)
  end

  @doc """
  Analyzes listening patterns to identify trends and preferences.
  """
  def analyze_listening_patterns(%User{} = user) do
    recently_played = Client.get_recently_played(user, limit: 50)

    %{
      total_tracks: count_unique_tracks(recently_played),
      top_artists: analyze_top_artists(recently_played),
      listening_times: analyze_listening_times(recently_played),
      track_repeats: analyze_track_repeats(recently_played)
    }
  end

  # Private helper functions

  defp extract_track_ids_from_history(%{"items" => items}) do
    items
    |> Enum.map(fn item ->
      item["track"]["id"]
    end)
    |> Enum.uniq()
  end

  defp extract_track_ids_from_history(_), do: []

  defp extract_tracks_from_playlists(playlists, user) do
    playlists
    |> Enum.flat_map(fn playlist ->
      # Get tracks from each playlist
      playlist_tracks = get_playlist_tracks(playlist["id"], user)

      case playlist_tracks do
        %{"items" => items} ->
          items
          |> Enum.map(fn item ->
            track = item["track"]

            %{
              id: track["id"],
              name: track["name"],
              artists: track["artists"],
              album: track["album"],
              playlist_name: playlist["name"],
              playlist_id: playlist["id"],
              added_at: item["added_at"]
            }
          end)

        _ ->
          []
      end
    end)
    |> Enum.reject(&is_nil(&1[:id]))
  end

  defp get_playlist_tracks(playlist_id, user) do
    user_token =
      user
      |> SpotifyReDiscoverer.Repo.preload(:spotify_credentials)
      |> Map.get(:spotify_credentials)
      |> Map.get(:access_token)

    url = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"

    Req.get!(url, headers: %{"Authorization" => "Bearer #{user_token}"}).body
  end

  defp find_forgotten_tracks(playlist_tracks, recently_played_ids) do
    playlist_tracks
    |> Enum.reject(fn track ->
      track[:id] in recently_played_ids
    end)
  end

  defp score_forgotten_tracks(forgotten_tracks) do
    forgotten_tracks
    |> Enum.map(fn track ->
      # Calculate a score based on various factors
      score = calculate_forgotten_score(track)
      Map.put(track, :forgotten_score, score)
    end)
    |> Enum.sort_by(& &1.forgotten_score, :desc)
  end

  defp calculate_forgotten_score(track) do
    # Simple scoring algorithm - can be enhanced later
    base_score = 50

    # Boost score based on when track was added (older = higher score)
    added_at_score = calculate_age_score(track[:added_at])

    # Boost score for tracks from popular artists (more likely to be forgotten favorites)
    artist_score = length(track[:artists]) * 5

    base_score + added_at_score + artist_score
  end

  defp calculate_age_score(added_at) when is_binary(added_at) do
    case DateTime.from_iso8601(added_at) do
      {:ok, datetime, _} ->
        days_ago = DateTime.diff(DateTime.utc_now(), datetime, :day)
        # Older tracks get higher scores (max 30 points for tracks older than 30 days)
        min(days_ago, 30)

      _ ->
        0
    end
  end

  defp calculate_age_score(_), do: 0

  defp count_unique_tracks(%{"items" => items}) do
    items
    |> Enum.map(fn item -> item["track"]["id"] end)
    |> Enum.uniq()
    |> length()
  end

  defp count_unique_tracks(_), do: 0

  defp analyze_top_artists(%{"items" => items}) do
    items
    |> Enum.flat_map(fn item ->
      item["track"]["artists"]
    end)
    |> Enum.frequencies_by(fn artist -> artist["name"] end)
    |> Enum.sort_by(fn {_name, count} -> count end, :desc)
    |> Enum.take(5)
  end

  defp analyze_top_artists(_), do: []

  defp analyze_listening_times(%{"items" => items}) do
    items
    |> Enum.map(fn item ->
      case DateTime.from_iso8601(item["played_at"]) do
        {:ok, datetime, _} -> datetime.hour
        _ -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.frequencies()
    |> Enum.sort_by(fn {_hour, count} -> count end, :desc)
  end

  defp analyze_listening_times(_), do: []

  defp analyze_track_repeats(%{"items" => items}) do
    items
    |> Enum.frequencies_by(fn item -> item["track"]["id"] end)
    |> Enum.filter(fn {_id, count} -> count > 1 end)
    |> Enum.sort_by(fn {_id, count} -> count end, :desc)
    |> length()
  end

  defp analyze_track_repeats(_), do: 0
end
