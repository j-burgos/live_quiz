defmodule LiveQuiz.ControlPanelTest do
  use LiveQuiz.DataCase

  alias LiveQuiz.ControlPanel

  describe "questions" do
    alias LiveQuiz.ControlPanel.Question

    @valid_attrs %{content: "some content", category: "some cat", difficulty: "some dif"}
    @update_attrs %{
      content: "some updated content",
      category: "updated category",
      difficulty: "updated dif"
    }
    @invalid_attrs %{content: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ControlPanel.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert ControlPanel.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert ControlPanel.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = ControlPanel.create_question(@valid_attrs)
      assert question.content == "some content"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ControlPanel.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = ControlPanel.update_question(question, @update_attrs)
      assert question.content == "some updated content"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = ControlPanel.update_question(question, @invalid_attrs)
      assert question == ControlPanel.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = ControlPanel.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> ControlPanel.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = ControlPanel.change_question(question)
    end
  end
end
