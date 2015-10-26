defmodule PersonalTwitterBot.PageController do
  use PersonalTwitterBot.Web, :controller

  def index(conn, _params) do
    tweets = ExTwitter.search("elixir-lang", [count: 5]) |>
       Enum.map(fn(tweet) -> tweet.text end)
    render conn, "index.html", tweets: tweets
  end
end
