defmodule Flexiby.TestRouter do
  use Plug.Router

  alias Flexiby.Node

  plug :match
  plug :dispatch

  def read_template do
    case File.read("./site/index.html.eex") do
      {:ok, contents} -> contents
      {:error, _} -> nil
    end
  end

  def output do
    read_template()
    |> Node.from_string
    |> Node.render_to_string
  end

  match _ do
    conn |> send_resp(200, output())
  end
end
