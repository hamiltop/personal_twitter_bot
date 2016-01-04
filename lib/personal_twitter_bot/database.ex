defmodule Database do
  use RethinkDB.Ecto.Connection
  alias RethinkDB.Record
  alias RethinkDB.Collection

  def run_and_load(query, model) do
    case run(query) do
      %Record{data: data} ->
        Ecto.Schema.__load__(model, nil, nil, [], data, &load/2)
      %Collection{data: data} ->
        Enum.map data, fn (el) ->
          Ecto.Schema.__load__(model, nil, nil, [], el, &load/2)
        end
    end
  end

  def load(x, data) do
    IO.inspect {x, data}
    {:ok, data}
  end
  def load(_, data), do: {:ok, data}
end
