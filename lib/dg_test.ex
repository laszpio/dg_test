defmodule DgTest do
  @moduledoc false

  import DgTest.Solr
  alias DgTest.Solr.Cores
  alias DgTest.Solr.Schema
  alias DgTest.Ghost

  def reindex_posts() do
    Hui.update(
      posts_target(),
      %Ghost.Resource{name: "posts"}
      |> Ghost.Resource.all()
      |> Enum.map(&Map.from_struct/1)
    )
  end

  def posts_target() do
    %Hui.URL{
      url: target_url(),
      handler: "update",
      headers: [{"Content-type", "application/json"}]
    }
  end

  @spec recreate_index() :: no_return()
  def recreate_index do
    Cores.delete("items")
    Cores.create("items")
    Schema.add_field(:items, "domain", "string")
    Schema.add_field(:items, "slug", "string")
    Schema.add_field(:items, "title", "text_en")
    Schema.add_field(:items, "tags", "text_en", multi_valued: true)
    Schema.add_field(:items, "authors", "text_en", multi_valued: true)
    Schema.add_field(:items, "content", "text_en")
    Schema.add_field(:items, "published_at", "pdate")
    Schema.add_copy_field(:items, "*", "_text_")
  end
end
