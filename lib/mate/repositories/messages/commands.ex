defmodule Mate.Repositories.Messages.Commands do
  import Ecto.Query, warn: false
  alias Mate.Repositories.Messages.Changesets
  alias Mate.Repositories.Messages.Structs.Message
  alias Mate.Repo

  def create(%Ecto.Changeset{} = changeset) do
    Repo.insert(changeset)
  end

  def create(%Message{} = message) do
    message
    |> Message.to_attrs()
    |> create()
  end

  def create(attrs) do
    Changesets.new(attrs)
    |> create()
  end
end