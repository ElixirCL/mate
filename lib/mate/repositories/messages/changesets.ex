defmodule Mate.Repositories.Messages.Changesets do
  alias Mate.Repositories.Messages.Schema, as: Message

  def new(attrs) do
    %Message{}
    |> Message.changeset(attrs)
  end

  def empty() do
    new(%{})
  end
end