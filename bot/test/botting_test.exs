defmodule BottingTest do
  use ExUnit.Case
  doctest Botting

  test "greets the world" do
    assert Botting.hello() == :world
  end
end
