defmodule Mate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MateWeb.Telemetry,
      # Start the Ecto repository
      Mate.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mate.PubSub},
      # Start Finch
      {Finch, name: Mate.Finch},
      # Start the Endpoint (http/https)
      MateWeb.Endpoint,
      # Start the Discord Handler
      Discord
      # Start a worker by calling: Mate.Worker.start_link(arg)
      # {Mate.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
