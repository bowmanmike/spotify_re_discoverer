defmodule SpotifyReDiscovererWeb.Components.ConnectSpotifyButton do
  use SpotifyReDiscovererWeb, :live_component

  import SpotifyReDiscovererWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <p>Count: <%= @count %></p>
      <.button type="button" phx-click="click" phx-target={@myself}>Connect To Spotify</.button>
    </div>
    """
  end

  def mount(socket) do
    socket
    |> assign(:count, 0)
    |> reply_ok()
  end

  def handle_event("click", _params, socket) do
    socket
    |> update(:count, &(&1 + 1))
    |> noreply()
  end
end
