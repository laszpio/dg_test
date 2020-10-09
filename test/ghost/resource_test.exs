defmodule DgTest.Ghost.ResourceTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Resource

  @sample %Resource{
    name: "sample",
    domain: "http://sample.domain"
  }

  describe "pages_count/1" do
    test "returns Resource" do
      assert %Resource{} = Resource.pages_count(@sample)
    end
  end
end