defmodule Flexiby.Node do
  defstruct fs_path: nil,
    source: nil,
    body: nil,
    name: nil,
    ext: nil,
    full_name: nil,
    filters: [],
    children: []

  require Logger

  def create_from(path) do
    filename = Path.basename(path)
    [name | extensions] = String.split(filename, ".", trim: true)

    [ext | filters] = if Enum.any?(extensions) do
      extensions
    else
      [nil, []]
    end

    node = %__MODULE__{
      fs_path: path,
      name: name,
      ext: ext,
      full_name: "#{name}.#{ext}",
      filters: filters
    }

    if File.dir?(path) do
      read_directory(node)
    else
      %{node | source: File.read!(path)}
    end
  end

  def find_child(node, name) do
    IO.puts "looking for #{name}"
    Enum.find(node.children, fn(c) -> c.full_name == name end)
  end

  def read_directory(node) do
    files = File.ls!(node.fs_path)

    children = Enum.map files, fn(f) ->
      path = Path.join(node.fs_path, f)
      create_from(path)
    end

    %{node | children: children}
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
