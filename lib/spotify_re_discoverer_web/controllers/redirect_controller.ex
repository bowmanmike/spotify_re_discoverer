defmodule SpotifyReDiscovererWeb.RedirectController do
  use SpotifyReDiscovererWeb, :controller

  import SpotifyReDiscovererWeb.UserAuth, only: [fetch_current_user: 2]

  plug :fetch_current_user

  def redirect_if_authenticated(conn, _) do
    if conn.assigns.current_user do
      SpotifyReDiscovererWeb.UserAuth.redirect_if_user_is_authenticated(conn, [])
    else
      redirect(conn, to: ~p"/users/register")
    end
  end
end
