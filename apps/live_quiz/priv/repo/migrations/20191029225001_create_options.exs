defmodule LiveQuiz.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :content, :string
      add :is_correct, :boolean
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end
  end
end
