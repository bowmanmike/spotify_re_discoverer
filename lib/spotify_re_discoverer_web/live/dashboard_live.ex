defmodule SpotifyReDiscovererWeb.DashboardLive do
  use SpotifyReDiscovererWeb, :live_view

  alias SpotifyReDiscovererWeb.Components.ConnectSpotifyButton
  alias SpotifyReDiscoverer.Accounts

  def render(assigns) do
    ~H"""
    <p>Home</p>
    <%= if @current_user do %>
      <p><%= @current_user.email %></p>
      <.live_component module={ConnectSpotifyButton} id="spotify-button-dashboard" />
    <% end %>
    """
  end

  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(Map.get(session, "user_token", ""))

    socket
    |> assign(:current_user, current_user)
    |> reply_ok()
  end
end
