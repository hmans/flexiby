defmodule Flexiby.Builder do
  alias Flexiby.Node

  def from(path) do
    path
    |> File.read!
    |> Node.from_string
  end
end
