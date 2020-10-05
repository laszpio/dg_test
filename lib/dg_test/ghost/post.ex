defmodule DgTest.Ghost.Post do
  @moduledoc false

  defstruct [
    :id,
    :domain,
    :slug,
    :title,
    :content,
    :created_at,
    tags: [],
    authors: [],
  ]
end
