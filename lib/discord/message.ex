defmodule Discord.Message do
  alias Nostrum.Api

  def mention(user_id), do: "<@#{user_id}>"
  def send(channel, message), do: Api.create_message(channel, message)
end