defmodule DiscordBot do
  use Nostrum.Consumer

  def start_link() do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!lv" <> args ->
        DiscordBot.SearchCommand.command(msg, args)

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
