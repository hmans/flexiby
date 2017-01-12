defmodule Flexiby.Builder do
  alias Flexiby.Node

  def from(path) do
    source   = File.read!(path)
    filename = Path.basename(path)
    [name, ext | filters] = String.split(filename, ".", trim: true)
    code = compile(:eex, source)

    %Node{code: code, name: name, ext: ext, filters: filters}
  end

  defp compile(:eex, source, options \\ []) do
    EEx.compile_string(source, options)
  end
end
