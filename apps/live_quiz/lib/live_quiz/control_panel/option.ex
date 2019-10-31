defmodule LiveQuiz.ControlPanel.Option do
  @moduledoc """
    Provides an Option model
    An Option belongs to a Question
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    field :content, :string
    field :is_correct, :boolean
    belongs_to :question, LiveQuiz.ControlPanel.Question

    timestamps()
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:content, :is_correct])
    |> validate_required([:content, :is_correct])
  end
end
