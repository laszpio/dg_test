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
      assert Post.extract(:title, "Title", nil) == "Title"
      assert Post.extract(:title, nil, "Default") == "Default"
    end

    test "strips html" do
      assert Post.extract(:title, "<h1>Title</h1>", nil) == "Title"
    end
  end
end
