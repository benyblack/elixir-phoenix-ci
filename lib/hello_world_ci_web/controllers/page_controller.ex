defmodule HelloWorldCiWeb.PageController do
  use HelloWorldCiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
