defmodule SdvxBotTest do
  use ExUnit.Case
  doctest SdvxBot

  test "greets the world" do
    assert SdvxBot.hello() == :world
  end
end
