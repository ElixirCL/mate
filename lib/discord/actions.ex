defmodule Discord.Actions do
  alias Discord.Message
  alias Mate.Repositories.Mates
  require Logger

  def give_mate(%_{mentions: [user | _rest]} = msg, 1) do
    case Mates.send_mate(
           id: msg.id,
           from: msg.author,
           to: user,
           channel: msg.channel_id,
           guild: msg.guild_id,
           content: msg.content
         ) do
      {:ok, _, count} ->
        Message.send(
          msg.channel_id,
          "Awesome!, :mate: was given to #{Message.mention(user.id)}. Today you have sent #{count + 1}/#{Mates.max()} :mate:."
        )

      {:error, :MAX_MATES_PER_DAY_REACHED, count} ->
        Message.send(
          msg.channel_id,
          "Oh no!. Your :mate: stock (#{count}/#{Mates.max()}}) is empty. Please wait until tomorrow to send more."
        )

      {:error, :SAME_PERSON, usr} ->
        Message.send(
          msg.channel_id,
          "Yikes! #{Message.mention(usr.id)}. Please send :mate: to another person."
        )

      error ->
        Logger.error(error)

        Message.send(
          msg.channel_id,
          "Something went wrong :bomb:. Please contact an admin or moderator."
        )
    end
  end

  def give_mate(_msg, 0) do
    # If just used the :mate: emoji do not send a message, is annoying.
    # but you can uncomment this if you want to respond to that anyway
    # Message.send(msg.channel_id, "Wait! #{Message.mention(msg.author.id)}, please mention one person to give :mate:. Thanks.")
    :noop
  end

  def give_mate(msg, _mentions_count) do
    Message.send(
      msg.channel_id,
      "Sorry #{Message.mention(msg.author.id)}, I only can give one :mate: at a time. Please mention only one person to give :mate:. Thanks."
    )
  end

  def add_reaction(msg, emojis \\ ["🧉", "🧙", "🎉", "👍", "👀", "🔥", "🚀", "☕", "✨", "⭐"]) do
    Message.add_reaction(msg.channel_id, msg.id, emojis)
  end
end
