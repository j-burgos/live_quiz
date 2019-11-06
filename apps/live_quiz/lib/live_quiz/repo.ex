defmodule LiveQuiz.Repo do
  use Ecto.Repo, otp_app: :live_quiz, adapter: Ecto.Adapters.Postgres
  use Scrivener
end
