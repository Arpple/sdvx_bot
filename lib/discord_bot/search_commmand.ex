defmodule DiscordBot.SearchCommand do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed

  @search_pattern ~r/(?<level>\d+)([ ]+(?<keyword>.*))?/

  def command(msg, raw_args) do
    raw_args
    |> parse_args()
    |> search()
    |> message(msg.channel_id, raw_args)
  end

  defp parse_args(args) do
    Regex.named_captures(@search_pattern, String.trim(args))
  end

  defp search(%{ "keyword" => keyword, "level" => level }) do
    SdvxBot.search(level, keyword)
  end

  defp message(tracks, channel, _) when length(tracks) == 0 do
    Api.create_message(channel, "Not Found :jarnsweat:")
  end

  defp message(tracks, channel, args) when length(tracks) > 15 do
    create_embed(Enum.slice(tracks, 0..14), args)
    |> Embed.put_field("and more", "...")
    |> send_embed(channel)
  end

  defp message(tracks, channel, args) do
    create_embed(tracks, args)
    |> send_embed(channel)
  end

  defp create_embed(tracks, args) do
    fields = tracks
    |> Enum.map(&track_string/1)
    |> Enum.join("\n")

    %Embed{}
    |> Embed.put_title("Search #{args}")
    |> Embed.put_field("Result", fields)
  end

  defp send_embed(embed, channel) do
    Api.create_message(channel, embed: embed)
  end

  defp track_string(%{ name: name, link: link }) do
    "[#{name}](#{link})"
  end
end
