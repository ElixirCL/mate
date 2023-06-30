defmodule Mate.Repositories.Messages.Structs.Message do

  defstruct ~w(id type channel guild user)a

  alias __MODULE__

  def new(id, type, channel, guild, user) do
    %Message{
      id: id,
      type: type,
      channel: channel,
      guild: guild,
      user: user
    }
  end

  def to_attrs(%Message{} = message) do
    %{
      message_id: message.id,
      message_type: message.type,
      channel_id: message.channel,
      guild_id: message.guild,
      from_user_id: message.user.id,
    }
  end
end