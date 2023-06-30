defmodule Mate.Repositories.Mates.Structs do
  defmodule Give do
    alias __MODULE__
    defstruct ~w(id from to channel guild content)a

    def new(id, from, to, channel, guild, content) do
      %Give{
        id: id,
        from: from,
        to: to,
        channel: channel,
        guild: guild,
        content: content,
      }
    end

    def to_attrs(%Give{} = give) do
      %{
        message_id: give.id,
        from_user_id: give.from.id,
        from_user_name: give.from.username,
        to_user_id: give.to.id,
        to_user_name: give.to.username,
        channel_id: give.channel,
        guild_id: give.guild,
      }
    end
  end

  defmodule TopUser do
    alias __MODULE__
    defstruct ~w(id name count sort)a

    def new(id, count, sort) do
      %TopUser{
        id: id,
        name: "<@#{id}>",
        count: count,
        sort: sort
      }
    end
  end

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