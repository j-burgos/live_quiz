defmodule Mix.Tasks.LiveQuiz.ImportQuestions do
  @moduledoc """
  Provides tasks used for importing questions from external sources
  Example:
    mix live_quiz.import_questions <amount>
  """
  use Mix.Task
  require Logger

  @shortdoc "Import questions from OpenTriviaDB"
  def run([amount]) do
    # This with_repo function is necessary to not start the whole application
    Ecto.Migrator.with_repo(LiveQuiz.Repo, fn _ ->
      questions = LiveQuiz.DataSources.OpenTriviaDb.questions(amount)

      questions
      |> add_questions
      |> add_questions_options
    end)
  end

  def run(_) do
    Logger.error("Usage: mix import_questions <amount>")
  end

  defp add_questions(questions) do
    questions |> Enum.map(&add_question/1)
  end

  defp add_question(question) do
    %{
      "category" => category,
      "difficulty" => difficulty,
      "question" => content,
      "correct_answer" => correct,
      "incorrect_answers" => incorrect
    } = question

    question_to_insert = %LiveQuiz.ControlPanel.Question{
      category: category,
      difficulty: difficulty,
      content: content
    }

    db_question = LiveQuiz.Repo.insert!(question_to_insert)
    {db_question, %{:correct => correct, :incorrect => incorrect}}
  end

  defp add_questions_options(question_options) do
    question_options
    |> Enum.each(fn question_with_options ->
      {question, %{:correct => correct, :incorrect => incorrect}} = question_with_options
      add_question_option(question, correct, incorrect)
    end)
  end

  defp add_question_option(question, correct, incorrect) do
    correct_option = add_option(question, correct, true)
    incorrect_options = incorrect |> Enum.each(fn opt -> add_option(question, opt) end)
    options = [correct_option] ++ incorrect_options
    {question, options}
  end

  defp add_option(question, option_content, is_correct \\ false) do
    option_to_insert = %LiveQuiz.ControlPanel.Option{
      content: option_content,
      is_correct: is_correct
    }

    opt = Ecto.build_assoc(question, :options, option_to_insert)
    LiveQuiz.Repo.insert!(opt)
  end
end
