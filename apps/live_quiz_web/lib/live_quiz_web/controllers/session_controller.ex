defmodule LiveQuizWeb.SessionController do
  use LiveQuizWeb, :controller

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => session_params}) do
    %{"email" => email, "password" => password} = session_params
    # here will be an implementation
  end

  def delete(conn, _) do
    # here will be an implementation
  end
end
