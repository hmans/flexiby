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
    create_root()
  end

  match _ do
    node = find_node(conn)
    parts = String.split(conn.request_path, "/", trim: true)
    serve_node(parts, conn, node)
  end

  def serve_node([next | remaining], conn, node) do
    child = Node.find_child(node, next)

    if child do
      serve_node(remaining, conn, child)
    else
      # 404
      conn |> send_resp(404, "404")
    end
  end

  def serve_node([], conn, node) do
    if index = Node.find_child(node, "index.html") do
      serve_node([], conn, index)
    else
      node = Node.render(node)
      conn |> send_resp(200, node.body)
    end
  end
end
