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
    serve_node(remaining, conn, Node.find_child(node, next))
  end

  def serve_node(_, conn, nil) do
    conn |> send_resp(404, "404")
  end

  def serve_node([], conn, node) do
    case Node.find_child(node, "index.html") do
      nil ->
        node = Node.render(node)
        conn |> send_resp(200, node.body)
      index ->
        serve_node([], conn, index)
    end
  end
end
