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
        from_user_id: give.from.id,
        from_user_name: give.from.username,
        to_user_id: give.to.id,
        to_user_name: give.to.username,
        channel_id: give.channel,
        guild_id: give.guild,
      }
    end
  end

  # TODO: add month and year stats
  defmodule Stats do
    def new(
          today: [sent: sent, left: left, received: received, hours: hours],
          week: [sent: week_sent, received: week_received],
          month: [sent: month_sent, received: month_received],
          year: [sent: year_sent, received: year_received],
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
        month: %{
          sent: month_sent,
          received: month_received
        },
        year: %{
          sent: year_sent,
          received: year_received},
        total: %{
          sent: total_sent,
          received: total_received
        }
      }
    end
  end
end