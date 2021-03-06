defmodule LiveQuiz.ControlPanel do
  @moduledoc """
  The ControlPanel context.
  """

  import Ecto.Query, warn: false
  alias LiveQuiz.Repo

  alias LiveQuiz.ControlPanel.Question
  alias LiveQuiz.ControlPanel.Option

  require Logger

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions(params) do
    base_query = Question |> preload(:options)

    query =
      case params do
        %{"search" => search} ->
          base_query
          |> where(
            [q],
            ilike(q.content, ^"%#{search}%") or ilike(q.category, ^"%#{search}%") or
              ilike(q.difficulty, ^"%#{search}%")
          )

        _ ->
          base_query
      end

    query |> Repo.paginate(params)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id) do
    Question
    |> Repo.get!(id)
    |> Repo.preload(:options)
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  def correct?(question_id, option_id) do
    question = get_question!(question_id)
    found_option = question.options |> Enum.find(fn o -> o.id === option_id end)

    case found_option do
      nil -> false
      found_option -> found_option.is_correct
    end
  end
end
