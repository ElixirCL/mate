defmodule Mate.Repositories.Mates.Structs do
  defmodule Give do
    alias __MODULE__
    defstruct ~w(from to channel content guild)a

    def new(from, to, channel, guild, content) do
      %Give{
        from: from,
        to: to,
        channel: channel,
        guild: guild,
        content: content,
      }
    end

    def to_attrs(%Give{} = give) do
      %{
        from_user_id: give.from.id,
        to_user_id: give.to.id,
        channel_id: give.channel,
        guild_id: give.guild
      }
    end

    def from_schema(give) do
      new(give.from_user_id, give.to_user_id, give.channel_id, give.guild_id, give.content)
    end
  end
end