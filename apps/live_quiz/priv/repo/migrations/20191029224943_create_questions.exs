defmodule LiveQuiz.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :content, :string
      add :category, :string
      add :difficulty, :string

      timestamps()
    end
  end
end
