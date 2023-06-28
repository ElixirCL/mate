defmodule Mate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Mate.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mate.PubSub},
      # Start Finch
      {Finch, name: Mate.Finch}
      # Start a worker by calling: Mate.Worker.start_link(arg)
      # {Mate.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Mate.Supervisor)
  end
end
