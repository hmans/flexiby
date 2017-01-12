defmodule Flexiby.TestRouter do
  use Plug.Router

  alias Flexiby.Node

  plug Plug.Logger
  plug :match
  plug :dispatch

  def test_node do
    Node.from("./site/index.html.eex.foo")
    |> Node.render
  end

  match _ do
    conn |> send_resp(200, test_node().body)
  end
end
