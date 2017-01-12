defmodule Flexiby.Builder do
  alias Flexiby.Node

  def from(path) do
    source   = File.read!(path)
    filename = Path.basename(path)
    [name, ext | filters] = String.split(filename, ".", trim: true)

    code = Enum.map(filters, fn(f) -> compile(f, source) end)

    %Node{code: code, name: name, ext: ext, filters: filters}
  end

  defp compile("eex", source) do
    EEx.compile_string(source)
  end

  defp compile(_, _source) do
    []
  end
end
