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
      {:ok, _, count} ->
        Message.send(msg.channel_id, "Awesome!, :mate: was given to #{Message.mention(user.id)}. Today you have sent #{count + 1}/#{Mates.max} :mate:.")

      {:error, :MAX_MATES_PER_DAY_REACHED, count} ->
        Message.send(msg.channel_id, "Oh no!. Your :mate: stock (#{count}/#{Mates.max}}) is empty. Please wait until tomorrow to send more.")

      {:error, :SAME_PERSON, usr} ->
        Message.send(msg.channel_id, "Yikes! #{Message.mention(usr.id)}. Please send :mate: to another person.")

      error ->
        Logger.error(error)
        Message.send(msg.channel_id, "Something went wrong :bomb:. Please contact an admin or moderator.")
    end
  end

  defp give_mate(msg, mentions_count) do
    Logger.info("Do not give mate. Invalid mentions count: #{mentions_count}}")
    Message.send(msg.channel_id, "Sorry #{Message.mention(msg.author.id)}, I only can give one :mate: at a time. Please mention only one person to give :mate:. Thanks.")
  end

  defp is_mate_message(message) do
    case (String.split(message, "\n")
          |> length()) == 1 do
      true -> String.contains?(message, "🧉") ||
                String.contains?(message, ":mate:")
      _ -> false
    end
  end

  defp process_command(:stats, msg) do
    stats = Mates.stats(user: msg.author.id, guild: msg.guild_id)
    Message.send(msg.channel_id, """
# Stats
Hello #{Message.mention(msg.author.id)}. These are your stats.
## Today
- :mate: sent: *#{stats.today.sent}*
- :mate: left: *#{stats.today.left}*
- :mate: received: *#{stats.today.received}*
- :alarm_clock: hours until renewal: *#{stats.today.hours}*
## Week
- :mate: sent: *#{stats.week.sent}*
- :mate: received: *#{stats.week.received}*
## Total
- :mate: sent: *#{stats.total.sent}*
- :mate: received: *#{stats.total.received}*
""")
  end

  defp handle_command(text, msg) do
    case text do
      "!stats" -> process_command(:stats, msg)
      "!mate.stats" -> process_command(:stats, msg)
      _ ->
        {:error, :MATE_HANDLER_NOT_FOUND}
    end
  end

  def handle_event({:MESSAGE_CREATE, %Nostrum.Struct.Message{author: %Nostrum.Struct.User{bot: nil}} = msg, _ws_state}) do
    case is_mate_message(msg.content) do
      true ->
        give_mate(msg, Enum.count(msg.mentions))
      false ->
        handle_command(msg.content, msg)
    end
  end

  def handle_event(_event) do
    {:error, :EVENT_NOT_FOUND}
  end
end