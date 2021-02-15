defmodule DgTest.Ghost.ItemTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Item

  @sample_source %{
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
      assert %Item{created_at: created_at} = Item.new(%{})
      assert created_at <= DateTime.utc_now |> DateTime.to_iso8601
    end

    test "maps keys when defined" do
      assert %Item{content: "Content here"} = Item.new(%{"html" => "Content here"})
    end

    test "maps collections when defined" do
      assert %Item{authors: [%{"name" => "Author A"}, %{"name" => "Author B"}]}
      assert %Item{tags: [%{"name" => "Tag A"}, %{"name" => "Tag B"}]}
    end

    test "returns Post" do
      assert Item.new(@sample_source) == %Item{
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
      assert Item.extract(:title, "Title", nil) == "Title"
      assert Item.extract(:title, nil, "Default") == "Default"
    end

    test "strips html" do
      assert Item.extract(:title, "<h1>Title</h1>", nil) == "Title"
    end
  end

  describe "sanitize/1" do
    test "removes HTML tags" do
      assert Item.sanitize("<h1>Title</h1>") == "Title"
    end

    test "removes Javascript" do
      assert Item.sanitize("<button onclick=\"alert('pwnt')\">Hi!</button>") == "Hi!"
    end

    test "trims whitespaces" do
      assert Item.sanitize("\n\n\nBig Title\n\r") == "Big Title"
    end
  end
end
