defmodule Flexiby.TestRouter do
  use Plug.Router

  alias Flexiby.Node
  alias Flexiby.Builder

  plug :match
  plug :dispatch

  def output do
    Builder.from("./site/index.html.eex.foo")
    |> Node.render_to_string
  end

  match _ do
    conn |> send_resp(200, output())
  end
end
