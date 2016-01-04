defmodule PersonalTwitterBot.Repo.Migrations.CreateFilter do
  use Ecto.Migration

  def change do
    create table(:filters) do
      add :term, :string

      timestamps
    end

  end
end
