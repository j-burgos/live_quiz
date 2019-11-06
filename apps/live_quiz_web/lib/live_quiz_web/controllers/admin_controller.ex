defmodule LiveQuizWeb.AdminController do
  use LiveQuizWeb, :controller
  alias LiveQuiz.Repo

  require Logger

  def index(conn, params) do
    page = LiveQuiz.ControlPanel.list_questions(params)
    questions = page.entries

    render(conn, "index.html",
      questions: questions,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end
end
