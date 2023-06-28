defmodule Mate.Repositories.Mates.Structs do
  defmodule Give do
    alias __MODULE__
    defstruct ~w(from to channel guild content)a

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
        from_user_id: to_string(give.from.id),
        from_user_name: to_string(give.from.username),
        to_user_id: to_string(give.to.id),
        to_user_name: to_string(give.to.username),
        channel_id: to_string(give.channel),
        guild_id: to_string(give.guild)
      }
    end
  end

  defmodule Stats do
    def new(
          today: [sent: sent, left: left, received: received, hours: hours],
          week: [sent: week_sent, received: week_received],
          total: [sent: total_sent, received: total_received]
        ) do
      %{
        today: %{
          sent: sent,
          left: left,
          received: received,
          hours: hours
        },
        week: %{
          sent: week_sent,
          received: week_received
        },
        total: %{
          sent: total_sent,
          received: total_received
        }
      }
    end
  end
end