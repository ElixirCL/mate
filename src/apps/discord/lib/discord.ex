defmodule Discord do
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Api
  alias Mate.Repositories.Mates

  defmodule Message do
    def mention(user_id), do: "<@#{user_id}>"
    def send(channel, message), do: Api.create_message(channel, message)
  end

  defp give_mate(%_{mentions: [user | _rest]} = msg, 1) do
    case Mates.send_mate(from: msg.author, to: user, channel: msg.channel_id, guild: msg.guild_id, content: msg.content) do
      {:ok, _, count} -> Message.send(msg.channel_id, "Awesome!, :mate: was given to #{Message.mention(user.id)}. You have sent #{count + 1} :mate: so far today.")
      {:error, :MAX_MATES_PER_DAY_REACHED, count} -> Message.send(msg.channel_id, "Oh no!. Your :mate: stock (#{count}) is empty. Please wait until tomorrow to send more.")
      error ->
        Logger.error(error)
        Message.send(msg.channel_id, "Something went wrong :bomb:. Please contact an admin or moderator.")
    end
  end

  defp give_mate(msg, mentions_count) do
    Logger.info("Do not give mate. Invalid mentions count: #{mentions_count}}")
    Message.send(msg.channel_id, "Sorry #{Message.mention(msg.author.id)}, I only can give one :mate: at a time. Please mention only one person to give :mate:. Thanks.")
  end

  defp is_valid_message(message) do
    case (String.split(message, "\n")
          |> length()) == 1 do
      true -> String.contains?(message, "🧉") ||
                String.contains?(message, ":mate:")
      _ -> false
    end
  end

  def handle_event({:MESSAGE_CREATE, %Nostrum.Struct.Message{author: %Nostrum.Struct.User{bot: nil}} = msg, _ws_state}) do
    case is_valid_message(msg.content) do
      true -> give_mate(msg, Enum.count(msg.mentions))
      _ ->
        {:error, :MATE_NOT_FOUND}
    end
  end

  def handle_event(_event) do
    {:error, :EVENT_NOT_FOUND}
  end
end
