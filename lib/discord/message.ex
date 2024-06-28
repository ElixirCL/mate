defmodule Discord.Message do
  alias Nostrum.Api

  def mention(user_id), do: "<@#{user_id}>"
  def send(channel_id, text), do: Api.create_message(channel_id, text)

  def add_reaction(channel_id, message_id, emojis \\ ["🧉", "❤️‍🔥", "🧙", "🦄", "🍻"]) do
    Api.create_reaction(
      channel_id,
      message_id,
      Enum.random(emojis)
    )
  end
end
