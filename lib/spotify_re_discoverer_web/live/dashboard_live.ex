defmodule SpotifyReDiscovererWeb.DashboardLive do
  use SpotifyReDiscovererWeb, :live_view

  alias SpotifyReDiscovererWeb.Components.ConnectSpotifyButton
  alias SpotifyReDiscoverer.{Accounts, Spotify}
  alias SpotifyReDiscoverer.Spotify.Client

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
    |> reply_ok()
  end

  def handle_event("get_playlists", _params, socket) do
    playlists = Client.get_all_playlists(socket.assigns.current_user)

    socket
    |> assign(:playlists, playlists)
    |> noreply()
  end
end
