defmodule Discord do
  @moduledoc """
Main Discord Handler.
"""
  use Nostrum.Consumer

  alias Discord.Commands
  alias Discord.Actions
  alias Mate.Repositories.Messages
  alias Mate.Repositories.Messages.Structs.Message

  defp is_mate_message(message) do
    case (String.split(message, "\n")
          |> length()) == 1 do
      true -> String.contains?(message, "🧉") ||
                String.contains?(message, ":mate:")
      _ -> false
    end
  end

  defp is_command_message(text) do
    String.trim(text)
    |> String.downcase()
    |> Kernel.in(["!stats", "!mate.stats", "!top", "!mate.top"])
  end

  defp handle_command(text, msg) do
    case String.trim(text)
         |> String.downcase() do
      # Personal Stats
      "!stats" -> Commands.handle(:stats, msg)
      "!mate.stats" -> Commands.handle(:stats, msg)

      # Top 3 Leaderboard
      "!top" -> Commands.handle(:top, msg)
      "!mate.top" -> Commands.handle(:top, msg)
      _ ->
        {:error, :MATE_HANDLER_NOT_FOUND}
    end
  end

  defp message_type(msg) do
    case is_mate_message(msg.content) do
      true -> Messages.type_mate()
      false -> case is_command_message(msg.content) do
        true -> Messages.type_command()
        false -> Messages.type_undefined()
      end
    end
  end

  def handle_event({:MESSAGE_CREATE, %Nostrum.Struct.Message{author: %Nostrum.Struct.User{bot: nil}} = msg, _ws_state}) do
    case Message.new(msg.id, message_type(msg), msg.channel_id, msg.guild_id, msg.author)
    |> Messages.can_be_saved?() do
      true -> case is_mate_message(msg.content) do
                true ->
                  Actions.give_mate(msg, Enum.count(msg.mentions))
                false ->
                  handle_command(msg.content, msg)
              end
      false -> {:ok, :MESSAGE_ALREADY_PROCESSED}
    end
  end

  def handle_event(_event) do
    {:error, :EVENT_NOT_FOUND}
  end
end
