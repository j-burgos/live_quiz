defmodule LiveQuiz.OpenTriviaDb do
  @moduledoc """
    Provides getting trivia questions from OpenTriviaDB api
  """
  use Tesla

  require Logger

  @base_url "https://opentdb.com"

  def questions(amount) do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      {Tesla.Middleware.Query, [amount: amount]},
      Tesla.Middleware.JSON
    ]

    client = Tesla.client(middleware)

    case Tesla.get(client, "/api.php") do
      {:ok, response} ->
        %{"results" => results} = response.body
        results

      err ->
        Logger.error(inspect(err))
        []
    end
  end
end
