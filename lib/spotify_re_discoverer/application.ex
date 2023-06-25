defmodule SpotifyReDiscoverer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    LoggerBackends.add(Sentry.LoggerBackend)

    children = [
      # Start the Telemetry supervisor
      SpotifyReDiscovererWeb.Telemetry,
      # Start the Ecto repository
      SpotifyReDiscoverer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SpotifyReDiscoverer.PubSub},
      # Start Finch
      {Finch, name: SpotifyReDiscoverer.Finch},
      # Start the Endpoint (http/https)
      SpotifyReDiscovererWeb.Endpoint
      # Start a worker by calling: SpotifyReDiscoverer.Worker.start_link(arg)
      # {SpotifyReDiscoverer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SpotifyReDiscoverer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpotifyReDiscovererWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
