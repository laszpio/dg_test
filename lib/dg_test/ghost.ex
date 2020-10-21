defmodule DgTest.Ghost do
  use DynamicSupervisor

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def connect(domain, api, key) do
    DynamicSupervisor.start_child(__MODULE__, {DgTest.Ghost.Client, {domain, api, key}})
  end
end
