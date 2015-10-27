defmodule PersonalTwitterBot.PageController do
  use PersonalTwitterBot.Web, :controller

  def index(conn, _params) do
    tweets = ExTwitter.search("elixir-lang", [count: 5]) |>
       Enum.map(fn(tweet) -> tweet.text end)
    table_query = RethinkDB.Query.table("tweets") |> RethinkDB.Query.count
    table_count = case Database.run(table_query) do
      %RethinkDB.Record{data: c} -> c
      _ -> nil
    end
    render conn, "index.html", tweets: tweets, count: table_count
  end
end
