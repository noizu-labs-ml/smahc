defmodule Smahca.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SmahcaWeb.Telemetry,
      Smahca.Repo,
      {DNSCluster, query: Application.get_env(:smahca, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Smahca.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Smahca.Finch},
      # Start a worker by calling: Smahca.Worker.start_link(arg)
      # {Smahca.Worker, arg},
      # Start to serve requests, typically the last entry
      SmahcaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Smahca.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmahcaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
