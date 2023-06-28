defmodule DiscordTest do
  use ExUnit.Case
  doctest Discord

  test "greets the world" do
    assert Discord.hello() == :world
  end
end
