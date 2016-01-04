defmodule PersonalTwitterBot.FilterTest do
  use PersonalTwitterBot.ModelCase

  alias PersonalTwitterBot.Filter

  @valid_attrs %{term: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Filter.changeset(%Filter{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Filter.changeset(%Filter{}, @invalid_attrs)
    refute changeset.valid?
  end
end
