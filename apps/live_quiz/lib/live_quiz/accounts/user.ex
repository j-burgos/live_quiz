defmodule LiveQuiz.Accounts.User do
  @moduledoc """
    Provides a User model
  """
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :is_admin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :password_hash, :is_admin])
    |> validate_required([:email, :username])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:username, min: 6, max: 24)
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
