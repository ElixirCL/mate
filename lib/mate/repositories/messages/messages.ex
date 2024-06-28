defmodule Mate.Repositories.Messages do
  alias __MODULE__
  alias Messages.Commands
  alias Messages.Queries
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
  def if_can_be_saved_create_message(%Message{} = message) do
    case Commands.create(message) do
      {:ok, _result} ->
        true

      _error ->
        false
    end
  end

  @doc """
    Compares the current message with the last message saved
    if is the same user then it will return true
  """
  def is_same_user_from_last_message(user_id) do
    last_message = Queries.get_last_message()
    user_id == last_message.from_user_id
  end
end
