defmodule Flexiby.Node do
  defstruct code: nil, name: nil, ext: nil, filters: []

  def render_to_string(node, bindings \\ [], options \\ []) do
    {result, _} = Code.eval_quoted(node.code, bindings, options)
    result
  end
end
