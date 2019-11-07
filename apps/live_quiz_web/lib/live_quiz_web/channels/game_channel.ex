defmodule LiveQuizWeb.GameChannel do
  @moduledoc """
  Handles quiz game logic
  """
  use Phoenix.Channel

  require Logger

  def join("game:lobby", _params, socket) do
    {:ok, socket}
  end

  def handle_in("game:question:broadcast", %{"questionId" => question_id}, socket) do
    question = LiveQuiz.ControlPanel.get_question!(question_id)

    options =
      question.options
      |> Enum.map(fn o -> %{id: o.id, content: o.content} end)

    resp = %{
      question: %{
        id: question.id,
        content: question.content
      },
      options: options
    }

    broadcast!(socket, "game:question", resp)
    {:noreply, socket}
  end

  def handle_in("game:answer", %{"questionId" => question_id, "answerId" => answer_id}, socket) do
    option_id = String.to_integer(answer_id)
    result = LiveQuiz.ControlPanel.correct?(question_id, option_id)
    push(socket, "game:result", %{"optionId" => option_id, "result" => result})
    {:noreply, socket}
  end

  def handle_in("chat:message", %{"message" => message}, socket) do
    broadcast!(socket, "chat:message", %{message: message})
    {:noreply, socket}
  end
end
