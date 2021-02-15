defmodule DgTest.Ghost.Timestamp do
  @moduledoc false

  @spec utc_timestamp() :: binary
  def utc_timestamp(), do: DateTime.utc_now() |> DateTime.to_iso8601()
end
