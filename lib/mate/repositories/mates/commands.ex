defmodule Mate.Repositories.Mates.Commands do
  import Ecto.Query, warn: false
  alias Mate.Repositories.Mates.Changesets
  alias Mate.Repositories.Mates.Structs.Give
  alias Mate.Repo

  def create(%Ecto.Changeset{} = changeset) do
    Repo.insert(changeset)
  end

  def create(%Give{} = give) do
    give
    |> Give.to_attrs()
    |> create()
  end

  def create(attrs) do
    Changesets.new(attrs)
    |> create()
  end
end