defmodule LiveQuizWeb.Router do
  use LiveQuizWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveQuizWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/admin", LiveQuizWeb do
    pipe_through :browser

    # Admin panel
    get "/", AdminController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveQuizWeb do
  #   pipe_through :api
  # end
end
