defmodule SdvxInWeb.TrackSearch do
  def search(level) do
    level
    |> url()
    |> get_html_body()
    |> get_tracks()
  end

  defp url(level), do: "https://sdvx.in/sort/sort_#{level}.htm"

  defp get_html_body(url) do
    HTTPoison.get!(url).body
  end

  defp get_tracks(html) do
    html
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&convert_to_track/1)
    |> Enum.map(&get_track/1)
    |> Enum.filter(fn track -> !is_nil(track) end)
  end

  @regex ~r/<script>SORT(?<code>.+)(?<dif>.+)\(\);<\/script><!--(?<name>.+)-->/

  defp convert_to_track(line) do
    Regex.named_captures(@regex, line)
  end

  defp get_track(nil), do: nil

  defp get_track(%{ "code" => code, "dif" => dif, "name" => name }) do
    %{ name: name, link: track_link(code, dif) }
  end

  defp track_link(code, dif) do
    serieNumber = String.slice(code, 0..1)
    "https://sdvx.in/#{serieNumber}/#{code}#{String.downcase(dif)}.htm"
  end
end
