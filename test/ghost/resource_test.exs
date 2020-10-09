defmodule DgTest.Ghost.ResourceTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Resource

  @sample %Resource{
    name: "sample",
    domain: "http://sample.domain"
  }

  describe "structure" do
    test "" do
      assert %Resource{} = @sample
    end
  end
end
