defmodule Flexiby.NodePlug do
  use Plug.Router

  alias Flexiby.Node

  plug Plug.Logger
  plug :match
  plug :dispatch

  def create_root do
    Node.create_from("./site/")
  end

  def find_node(_conn) do
    create_root() |> Node.render
  end

  match _ do
    node = find_node(conn)
    serve_node(conn, node)
  end

  def serve_node(conn, node) do
    conn |> send_resp(200, node.body)
  end
end
