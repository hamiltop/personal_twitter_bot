defmodule PersonalTwitterBot.FilterControllerTest do
  use PersonalTwitterBot.ConnCase

  alias PersonalTwitterBot.Filter
  @valid_attrs %{term: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, filter_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing filters"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, filter_path(conn, :new)
    assert html_response(conn, 200) =~ "New filter"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, filter_path(conn, :create), filter: @valid_attrs
    assert redirected_to(conn) == filter_path(conn, :index)
    assert Repo.get_by(Filter, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, filter_path(conn, :create), filter: @invalid_attrs
    assert html_response(conn, 200) =~ "New filter"
  end

  test "shows chosen resource", %{conn: conn} do
    filter = Repo.insert! %Filter{}
    conn = get conn, filter_path(conn, :show, filter)
    assert html_response(conn, 200) =~ "Show filter"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, filter_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    filter = Repo.insert! %Filter{}
    conn = get conn, filter_path(conn, :edit, filter)
    assert html_response(conn, 200) =~ "Edit filter"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    filter = Repo.insert! %Filter{}
    conn = put conn, filter_path(conn, :update, filter), filter: @valid_attrs
    assert redirected_to(conn) == filter_path(conn, :show, filter)
    assert Repo.get_by(Filter, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    filter = Repo.insert! %Filter{}
    conn = put conn, filter_path(conn, :update, filter), filter: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit filter"
  end

  test "deletes chosen resource", %{conn: conn} do
    filter = Repo.insert! %Filter{}
    conn = delete conn, filter_path(conn, :delete, filter)
    assert redirected_to(conn) == filter_path(conn, :index)
    refute Repo.get(Filter, filter.id)
  end
end
