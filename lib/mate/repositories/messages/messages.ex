defmodule Mate.Repositories.Messages do
  alias __MODULE__
  alias Messages.Commands
  alias Messages.Structs.Message

  require Logger

  @type_mate 0
  @type_command 1
  @type_undefined -1

  def type_mate, do: @type_mate
  def type_command, do: @type_command
  def type_undefined, do: @type_undefined

  @doc """
  Will create a message.
    - Returns true if message was added
    - Returns false if the message already exists
  """
  def can_be_saved?(%Message{} = message) do
    case Commands.create(message) do
      {:ok, _result} -> true
      _error ->
        Logger.info("Message already in DB")
        false
    end
  end
end