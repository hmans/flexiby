defmodule Flexiby.Builder do
  alias Flexiby.Node

  def from(path) do
    path
    |> read_file
    |> Node.from_string
  end

  defp read_file(path) do
    case File.read(path) do
      {:ok, contents} -> contents
      {:error, _} -> nil
    end
  end
end
