defmodule SpotifyReDiscovererWeb.UnauthenticatedLive do
  use SpotifyReDiscovererWeb, :live_view

  alias SpotifyReDiscoverer.Accounts

  def render(assigns) do
    ~H"""
    <p>Welcome!</p>

    <p>
      Please <.link navigate={~p"/users/log_in"}>Log In</.link>
      or <.link navigate={~p"/users/register"}>Sign Up</.link>
      to use the site!
    </p>
    """
  end

  def mount(_params, session, socket) do
    case Accounts.get_user_by_session_token(session["user_token"]) do
      nil -> {:ok, socket}
      %Accounts.User{} -> {:ok, redirect(socket, to: ~p"/dashboard")}
    end
  end
end
