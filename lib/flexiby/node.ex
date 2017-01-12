defmodule Flexiby.Node do
  defstruct [:code]

  def from_string(source, options \\ []) do
    %__MODULE__{code: EEx.compile_string(source, options)}
  end

  def render_to_string(node, bindings \\ [], options \\ []) do
    {result, _} = Code.eval_quoted(node.code, bindings, options)
    result
  end
end
