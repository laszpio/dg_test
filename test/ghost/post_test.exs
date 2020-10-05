defmodule DgTest.Ghost.PostTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Post

  describe "new/1" do
    test "returns Post" do
      assert %Post{} = Post.new(%{})
    end
  end

  describe "extract/3" do
    test "returns string" do
      assert Post.extract(:title, "Title 1", nil) == "Title 1"
      assert Post.extract(:title, nil, "Default") == "Default"
    end
  end
end
