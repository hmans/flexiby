defmodule Flexiby.Node do
  defstruct fs_path: nil,
    source: nil,
    body: nil,
    name: nil,
    ext: nil,
    filters: []

  require Logger

  def from(path) do
    source   = File.read!(path)
    filename = Path.basename(path)
    [name, ext | filters] = String.split(filename, ".", trim: true)

    %__MODULE__{
      fs_path: path,
      source:  source,
      name:    name,
      ext:     ext,
      filters: filters
    }
  end

  def render(node) do
    Enum.reduce node.filters,
      %{node | body: node.source},
      fn(f, node) ->
        apply_filter(node, f)
      end
  end

  def apply_filter(node, "eex") do
    %{node | body: EEx.eval_string(node.body)}
  end

  def apply_filter(node, filter) do
    Logger.warn "Unknown filter '#{filter}' for #{Path.basename(node.fs_path)}"
    node
  end
end
