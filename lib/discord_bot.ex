defmodule DiscordBot do
  use Application

  def start(_type, _args) do
    children = [
      DiscordBot.Consumer
    ]

    opts = [strategy: :one_for_one, name: DiscordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
