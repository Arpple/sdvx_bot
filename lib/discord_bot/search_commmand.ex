defmodule DiscordBot.SearchCommand do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Interaction

  @search_pattern ~r/(?<level>\d+)([ ]+(?<keyword>.*))?/

  def command_message(msg, raw_args) do
    raw_args
    |> parse_string_args()
    |> search()
    |> create_embed(raw_args)
    |> send_message(msg.channel_id)
  end

  def command_slash(%Interaction{data: %{options: options}} = interaction) do
    %{value: level} = Enum.find(options, fn option -> option.name == "level" end)
    %{value: keyword} = Enum.find(options, %{value: ""}, fn option -> option.name == "keyword" end)
    search(%{ "keyword" => keyword, "level" => level })
    |> create_embed("#{level} #{keyword}")
    |> send_response(interaction)
  end

  defp parse_string_args(args) do
    Regex.named_captures(@search_pattern, String.trim(args))
  end

  defp search(%{ "keyword" => keyword, "level" => level }) do
    SdvxInWeb.search(level, keyword)
  end

  defp send_message(nil, channel) do
    Api.create_message(channel, "Not Found :jarnsweat:")
  end

  defp send_message(embed, channel) do
    Api.create_message(channel, embed: embed)
  end

  defp create_embed(tracks, _args) when length(tracks) == 0, do: nil

  defp create_embed(tracks, args) when length(tracks) <= 15 do
    fields = tracks
    |> Enum.map(&track_string/1)
    |> Enum.join("\n")

    %Embed{}
    |> Embed.put_title("Search #{args}")
    |> Embed.put_field("Result", fields)
  end

  defp create_embed(tracks, args) do
    create_embed(Enum.slice(tracks, 0..14), args)
    |> Embed.put_field("and more", "...")
  end

  defp send_response(embed, interaction) do
    response = %{
      type: 4, # CHANNEL_MESSAGE_WITH_SOURCE
      data: %{
        embed: embed,
      },
    }

    Api.create_interaction_response(interaction, response)
  end

  defp track_string(%{ name: name, link: link }) do
    "[#{name}](#{link})"
  end
end
