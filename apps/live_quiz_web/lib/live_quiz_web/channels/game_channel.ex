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
      question: question.content,
      options: options
    }

    broadcast!(socket, "game:question", resp)
    {:noreply, socket}
  end

  def handle_in("game:answer", _params, socket) do
    push(socket, "game:result", %{result: false})
    {:noreply, socket}
  end

  def handle_in("chat:message", %{"message" => message}, socket) do
    broadcast!(socket, "chat:message", %{message: message})
    {:noreply, socket}
  end
end
