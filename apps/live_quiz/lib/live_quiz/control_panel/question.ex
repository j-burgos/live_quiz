defmodule LiveQuiz.ControlPanel.Question do
  @moduledoc """
    Provides a Question model
    A Model has many Options
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :content, :string
    field :category, :string
    field :difficulty, :string
    has_many :options, LiveQuiz.ControlPanel.Option

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:content, :category, :difficulty])
    |> validate_required([:content, :category, :difficulty])
  end
end
