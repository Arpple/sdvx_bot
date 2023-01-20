defmodule DiscordBot.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  def start_link() do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, %{guilds: guilds}, _ws_state}) do
    guilds
    |> Enum.map(fn guild -> guild.id end)
    |> Enum.each(&create_guild_commands/1)
  end

  @command %{
    name: "search",
    description: "search tracks from sdvx.in",
    options: [
      %{
        type: 4, #INTEGER
        name: "level",
        description: "target level to search",
        required: true,
      },
      %{
        type: 3, #STRING
        name: "keyword",
        description: "keyword to search",
        required: false,
      },
    ],
  }

  defp create_guild_commands(guild_id) do
    Api.bulk_overwrite_guild_application_commands(guild_id, @command)
  end

  def handle_event({:INTERACTION_CREATE, %Interaction{data: %{name: "search"}} = interaction, _ws_state}) do
    DiscordBot.SearchCommand.command_slash(interaction)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!lv" <> args ->
        DiscordBot.SearchCommand.command_message(msg, args)

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
