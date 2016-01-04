defmodule PersonalTwitterBot.Filter do
  use PersonalTwitterBot.Web, :model

  import RethinkDB.Query, only: [table: 1, get: 2, insert: 2]
  alias RethinkDB.Query
  alias RethinkDB.Record

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "filters" do
    field :term, :string

    timestamps
  end

  @required_fields ~w(term)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  after_load :inspect_load
  
  def inspect_load(model) do
    IO.inspect {:callback, model}
    model
  end

  def all do
    table("filters") |> Database.run |> Enum.map(&parse/1)
  end

  def insert(changeset) do
    filter = changeset
      |> Ecto.Changeset.apply_changes
      |> Map.from_struct
      |> Map.delete(:__meta__)
      |> Map.delete(:id)
      |> Map.put(:inserted_at, Query.now)
      |> Map.put(:updated_at, Query.now)
    res = table("filters") |> insert(filter) |> Database.run
    case res do
      %Record{data: %{"inserted" => 1, "generated_keys" => [id]}} ->
        filter = Map.put(filter, :id, id)
        filter = struct(__MODULE__, filter)
        {:ok, filter}
      _ ->
        {:error, changeset}
    end
  end

  def update(changeset) do
    filter = changeset
      |> Ecto.Changeset.apply_changes
      |> Map.from_struct
      |> Map.delete(:__meta__)
      |> Map.put(:updated_at, Query.now)
    res = table("filters") |> get(filter[:id]) |> Query.update(filter) |> Database.run
    case res do
      %Record{data: %{"updated" => 1}} ->
        filter = struct(__MODULE__, filter)
        {:ok, filter}
      _ ->
        {:error, changeset}
    end
  end

  def get(id) do
    %Record{data: filter} = table("filters") |> get(id) |> Database.run
    parse(filter)
  end

  def parse(m) do
    filter = Enum.map(m, fn {k,v} ->
      {String.to_existing_atom(k), v}
    end) |> Enum.into(%{})
    filter = struct(__MODULE__, filter)
    meta = Map.get(filter, :__meta__)
    Map.put(filter, :__meta__, Map.put(meta, :state, :loaded))
  end

  def delete(id) do
    table("filters") |> get(id) |> Query.delete |> Database.run  
  end
end
