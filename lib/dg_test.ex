defmodule DgTest do
  @moduledoc false

  import DgTest.Solr
  alias DgTest.Solr.{Core, Schema}
  alias DgTest.Ghost.Crawler

  def reindex do
    Hui.update(target(), items())
  end

  def items do
    %Crawler{
      domain: "https://productmarketingalliance.com",
      api_url: Application.fetch_env!(:dg_test, :ghost_api),
      api_key: Application.fetch_env!(:dg_test, :ghost_key)
    }
    |> Crawler.connect()
    |> Crawler.resources()
    |> Crawler.fetch()
    |> Crawler.items()
  end

  def target do
    %Hui.URL{
      url: target_url(),
      handler: "update",
      headers: [{"content-type", "application/json"}]
    }
  end

  @spec recreate_index() :: no_return()
  def recreate_index do
    Core.delete("items")
    Core.create("items")
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
