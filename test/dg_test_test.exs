defmodule DgTestTest do
  use ExUnit.Case
  doctest DgTest

  test "greets the world" do
    assert DgTest.hello() == :world
  end
end
