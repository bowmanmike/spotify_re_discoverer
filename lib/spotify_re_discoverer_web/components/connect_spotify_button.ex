defmodule SpotifyReDiscovererWeb.Components.ConnectSpotifyButton do
  use SpotifyReDiscovererWeb, :live_component

  import SpotifyReDiscovererWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <.button type="button" phx-click="click" phx-target={@myself}>Connect To Spotify</.button>
    </div>
    """
  end

  def handle_event("click", _params, socket) do
    noreply(socket)
  end
end
