defmodule ThreadCollectorTest do
  use ExUnit.Case
  doctest ThreadCollector

  test "greets the world" do
    assert ThreadCollector.hello() == :world
  end
end
