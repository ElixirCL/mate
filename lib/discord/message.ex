defmodule Discord.Message do
  alias Nostrum.Api

  def mention(user_id), do: "<@#{user_id}>"
  def send(channel_id, text), do: Api.create_message(channel_id, text)

  def add_reaction(channel_id, message_id, emojis \\ ["🧉"]) do
    case Enum.take_random(0..1000, 1) do
      [number]
      when number in [69, 420, 666, 777, 42, 18, 255, 0, 999, 443, 80, 400, 404, 200, 500] ->
        Api.create_reaction(
          channel_id,
          message_id,
          Enum.random(emojis)
        )

      _number ->
        nil
    end
  end
end
