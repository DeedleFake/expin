defmodule Expin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExpinWeb.Telemetry,
      Expin.Repo,
      {Oban, Application.fetch_env!(:expin, Oban)},
      {DNSCluster, query: Application.get_env(:expin, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Expin.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Expin.Finch},
      # Start a worker by calling: Expin.Worker.start_link(arg)
      # {Expin.Worker, arg},
      # Start to serve requests, typically the last entry
      ExpinWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Expin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExpinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
