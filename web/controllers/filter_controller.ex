defmodule PersonalTwitterBot.FilterController do
  use PersonalTwitterBot.Web, :controller

  alias PersonalTwitterBot.Filter

  plug :scrub_params, "filter" when action in [:create, :update]

  def index(conn, _params) do
    filters = Filter.all
    render(conn, "index.html", filters: filters)
  end

  def new(conn, _params) do
    changeset = Filter.changeset(%Filter{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"filter" => filter_params}) do
    changeset = Filter.changeset(%Filter{}, filter_params)

    case Filter.insert(changeset) do
      {:ok, _filter} ->
        conn
        |> put_flash(:info, "Filter created successfully.")
        |> redirect(to: filter_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    filter = Repo.get!(Filter, id)
    render(conn, "show.html", filter: filter)
  end

  def edit(conn, %{"id" => id}) do
    filter = Filter.get(id)
    changeset = Filter.changeset(filter)
    render(conn, "edit.html", filter: filter, changeset: changeset)
  end

  def update(conn, %{"id" => id, "filter" => filter_params}) do
    filter = Filter.get(id)
    changeset = Filter.changeset(filter, filter_params)

    case Filter.update(changeset) do
      {:ok, filter} ->
        conn
        |> put_flash(:info, "Filter updated successfully.")
        |> redirect(to: filter_path(conn, :show, filter))
      {:error, changeset} ->
        render(conn, "edit.html", filter: filter, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # PH: Removed bang
    Filter.delete(id)

    conn
    |> put_flash(:info, "Filter deleted successfully.")
    |> redirect(to: filter_path(conn, :index))
  end
end
