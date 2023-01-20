defmodule SdvxInWeb do
  alias SdvxInWeb.TrackSearch

  def search(level, "") do
    TrackSearch.search(level)
  end

  def search(level, keyword) do
    search(level, "")
    |> Enum.filter(fn track -> filter(track, keyword) end)
  end

  defp filter(%{name: name}, keyword) do
    String.contains?(String.downcase(name), String.downcase(keyword))
  end
end
