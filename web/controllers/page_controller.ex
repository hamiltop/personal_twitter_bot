defmodule PersonalTwitterBot.PageController do
  use PersonalTwitterBot.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
