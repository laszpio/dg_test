defmodule DgTest.Ghost.PostTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Post

  @sample_post %{
    "id" => "1234-5678-90AB",
    "domain" => "http://test.local",
    "slug" => "title-1234-5678-90AB",
    "title" => "Title",
    "html" => "<p>Sample post <b>content</b></p>.",
    "published_at" => "2020-10-02T16:52:52.000+00:00",
    "tags" => [
      %{"name" => "Tag1"},
      %{"name" => "Tag2"}
    ],
    "authors" => [
      %{"name" => "Author A"},
      %{"name" => "Author B"}
    ]
  }

  describe "new/1" do
    test "return empty" do
      assert %Post{} = Post.new(%{})
    end

    test "maps keys when defined" do
      assert %Post{content: "Content here"} = Post.new(%{"html" => "Content here"})
    end

    test "maps collections when defined" do
      assert %Post{authors: [%{"name" => "Author A"}, %{"name" => "Author B"}]}
      assert %Post{tags: [%{"name" => "Tag A"}, %{"name" => "Tag B"}]}
    end

    test "returns Post" do
      assert Post.new(@sample_post) == %Post{
               id: "1234-5678-90AB",
               domain: "http://test.local",
               slug: "title-1234-5678-90AB",
               title: "Title",
               content: "Sample post content.",
               published_at: "2020-10-02T16:52:52.000+00:00",
               tags: ["Tag1", "Tag2"],
               authors: ["Author A", "Author B"]
             }
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
