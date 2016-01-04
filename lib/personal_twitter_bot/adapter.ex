defmodule PersonalTwitterBot.RethinkDB.Adapter do
  defmacro __before_compile__(_) do
    :ok
  end

  def start_link(_,_) do
    {:ok, self}
  end

  def dump(:binary_id, str) do
    {:ok, str}
  end

  def prepare(:all, query) do
    IO.inspect query, struct: false
    table = query.from |> elem 0
    {:nocache, table}
  end

  def execute(repo, meta, table, [id], preprocess, opts) do
    res = RethinkDB.Query.table(table)
      |> RethinkDB.Query.get(id)
      |> Database.run
    case res do
      nil -> {0, []}
      data -> {1, data}
    end
  end
end
