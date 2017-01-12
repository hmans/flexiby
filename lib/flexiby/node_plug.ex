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
    serve_node(conn, node, parts)
  end

  def serve_node(conn, node, [next | remaining]) do
    serve_node(conn, Node.find_child(node, next), remaining)
  end

  def serve_node(conn, nil, _path) do
    conn |> send_resp(404, "404")
  end

  def serve_node(conn, node, []) do
    case Node.find_child(node, "index.html") do
      nil ->
        node = Node.render(node)
        conn |> send_resp(200, Flexiby.Layout.apply(node, nil))
      index ->
        serve_node(conn, index, [])
    end
  end
end
