defmodule Zumbi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Zumbi.Repo,
      # Start the Telemetry supervisor
      ZumbiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Zumbi.PubSub},
      # Start the Endpoint (http/https)
      ZumbiWeb.Endpoint
      # Start a worker by calling: Zumbi.Worker.start_link(arg)
      # {Zumbi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Zumbi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ZumbiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
