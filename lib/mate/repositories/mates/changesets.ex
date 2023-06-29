defmodule Mate.Repositories.Mates.Changesets do
  alias Mate.Repositories.Mates.Schema, as: Mate

  def new(attrs) do
    %Mate{}
    |> Mate.changeset(attrs)
  end

  def empty() do
    new(%{})
  end
end