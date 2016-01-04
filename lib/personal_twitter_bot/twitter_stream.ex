defmodule TwitterStream do
  use GenServer

  def start_link(topic) do
    GenServer.start_link(TwitterStream, [topic])
  end

  def init(topic) do
    target = self
    pid = spawn_link(fn ->
      stream = ExTwitter.stream_filter(track: topic)
        |> Stream.map(fn (tweet) ->
          send target, {:msg, self, tweet}
        end)
      Stream.run(stream)
    end)
    {:ok, pid}
  end

  def handle_info({:msg, pid, msg}, pid) do
    msg = msg |> Map.from_struct |> Map.delete(:__meta__)
    user = msg[:user] |> Map.from_struct |> Map.delete(:__meta__)
    msg = Map.put(msg, :user, user)
    RethinkDB.Query.table("tweets")
      |> RethinkDB.Query.insert(msg)
      |> Database.run
    {:noreply, pid}
  end
end
