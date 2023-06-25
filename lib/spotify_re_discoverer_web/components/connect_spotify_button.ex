defmodule SpotifyReDiscovererWeb.Components.ConnectSpotifyButton do
  use SpotifyReDiscovererWeb, :live_component

  import SpotifyReDiscovererWeb.CoreComponents

  alias SpotifyReDiscoverer.Spotify.Client

  def render(assigns) do
    ~H"""
    <div>
      <p>Count: <%= @count %></p>
      <.link navigate={Client.authorize_url()}>
        <.button type="button">Connect To Spotify</.button>
      </.link>
    </div>
    """
  end

  def mount(socket) do
    socket
    |> assign(:count, 0)
    |> reply_ok()
  end

  def handle_event("connect", _params, socket) do
    IO.puts(Client.authorize_url())

    socket
    |> redirect(external: Client.authorize_url())
    |> noreply()
  end
end
