defmodule SpotifyReDiscovererWeb.DashboardLive do
  use SpotifyReDiscovererWeb, :live_view

  alias SpotifyReDiscovererWeb.Components.ConnectSpotifyButton
  alias SpotifyReDiscoverer.{Accounts, Spotify}
  alias SpotifyReDiscoverer.Spotify.{Client, ListeningHistory}

  def render(assigns) do
    ~H"""
    <p>Home</p>
    <%= if @current_user do %>
      <p><%= @current_user.email %></p>
      <.live_component
        :if={!@current_user.spotify_credentials}
        module={ConnectSpotifyButton}
        id="spotify-button-dashboard"
      />

      <.button phx-click="get_playlists">Fetch Playlists</.button>
      <.button phx-click="analyze_forgotten_favorites">Find Forgotten Favorites</.button>
      
      <div :if={@forgotten_favorites != []}>
        <h2 class="text-xl font-bold mt-4 mb-2">Forgotten Favorites</h2>
        <p class="text-gray-600 mb-4">These tracks are in your playlists but haven't been played recently:</p>
        <div class="space-y-3">
          <%= for track <- @forgotten_favorites do %>
            <div class="bg-gray-50 p-4 rounded-lg">
              <h3 class="font-semibold"><%= track[:name] %></h3>
              <p class="text-gray-600">
                by <%= track[:artists] |> Enum.map(& &1["name"]) |> Enum.join(", ") %>
              </p>
              <p class="text-sm text-gray-500">
                From playlist: <%= track[:playlist_name] %>
              </p>
              <p class="text-sm text-gray-500">
                Forgotten score: <%= track[:forgotten_score] %>
              </p>
            </div>
          <% end %>
        </div>
      </div>

      <div :if={@listening_patterns}>
        <h2 class="text-xl font-bold mt-6 mb-2">Listening Patterns</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="bg-gray-50 p-4 rounded-lg">
            <h3 class="font-semibold mb-2">Recent Stats</h3>
            <p>Unique tracks: <%= @listening_patterns.total_tracks %></p>
            <p>Repeated tracks: <%= @listening_patterns.track_repeats %></p>
          </div>
          <div class="bg-gray-50 p-4 rounded-lg">
            <h3 class="font-semibold mb-2">Top Artists</h3>
            <%= for {artist, count} <- Enum.take(@listening_patterns.top_artists, 3) do %>
              <p><%= artist %> (<%= count %> plays)</p>
            <% end %>
          </div>
        </div>
      </div>

      <ul>
        <%= for playlist <- @playlists do %>
          <li><%= playlist["name"] %></li>
        <% end %>
      </ul>
    <% end %>
    """
  end

  def mount(_params, session, socket) do
    current_user =
      session
      |> Map.get("user_token", "")
      |> Accounts.get_user_by_session_token()
      |> Spotify.preload_credentials()

    socket
    |> assign(:current_user, current_user)
    |> assign(:playlists, [])
    |> assign(:forgotten_favorites, [])
    |> assign(:listening_patterns, nil)
    |> reply_ok()
  end

  def handle_event("get_playlists", _params, socket) do
    playlists = Client.get_all_playlists(socket.assigns.current_user)

    socket
    |> assign(:playlists, playlists)
    |> noreply()
  end

  def handle_event("analyze_forgotten_favorites", _params, socket) do
    user = socket.assigns.current_user
    
    # Analyze forgotten favorites
    forgotten_favorites = ListeningHistory.analyze_forgotten_favorites(user)
    
    # Analyze listening patterns
    listening_patterns = ListeningHistory.analyze_listening_patterns(user)
    
    socket
    |> assign(:forgotten_favorites, Enum.take(forgotten_favorites, 10))
    |> assign(:listening_patterns, listening_patterns)
    |> noreply()
  end
end
