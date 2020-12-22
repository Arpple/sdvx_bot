defmodule SdvxBot do
  alias SdvxBot.InWeb

  def search(level, "") do
    InWeb.tracks(level)
  end

  def search(level, keyword) do
    search(level, "")
    |> Enum.filter(fn track -> filter(track, keyword) end)
  end

  defp filter(%{name: name}, keyword) do
    String.contains?(String.downcase(name), String.downcase(keyword))
  end
end
