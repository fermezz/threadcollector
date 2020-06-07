defmodule ThreadCollector.Application do
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ThreadCollector.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: ThreadCollector.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
