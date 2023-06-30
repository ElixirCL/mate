defmodule Discord.Commands do
  alias Discord.Message
  alias Mate.Repositories.Mates

  def handle(:stats, msg) do
    stats = Mates.stats(user: msg.author.id, guild: msg.guild_id)
    Message.send(msg.channel_id, """
    # Stats
    Hello #{Message.mention(msg.author.id)}. These are your stats.
    - :alarm_clock: hours until renewal: **#{stats.today.hours}**
    ### Today
    - :mate: sent: **#{stats.today.sent}**
    - :mate: left: **#{stats.today.left}**
    - :mate: received: **#{stats.today.received}**
    ### Week
    - :mate: sent: **#{stats.week.sent}**
    - :mate: received: **#{stats.week.received}**
    ### Month
    - :mate: sent: **#{stats.month.sent}**
    - :mate: received: **#{stats.month.received}**
    ### Year
    - :mate: sent: **#{stats.year.sent}**
    - :mate: received: **#{stats.year.received}**
    ### Total
    - :mate: sent: **#{stats.total.sent}**
    - :mate: received: **#{stats.total.received}**
    """)
  end

  def handle(:top, msg) do
    top = Mates.top(msg.guild_id, :week)
    
    out = ["# Weekly Leaderboard\n"]

    out = top.giving
    |> Enum.reduce(out ++ ["### Top :mate: Giving\n"], fn item, acc ->
      place = case item.sort do
        0 -> ":first_place:"
        1 -> ":second_place:"
        2 -> ":third_place:"
        _ -> ""
      end
      acc ++ ["- #{place} #{item.name}: #{item.count} :mate:\n"]
    end)

    out = top.receiving
    |> Enum.reduce(out ++ ["### Top :mate: Receiving\n"], fn item, acc ->
      place = case item.sort do
        0 -> ":first_place:"
        1 -> ":second_place:"
        2 -> ":third_place:"
        _ -> ""
      end
      acc ++ ["- #{place} #{item.name}: #{item.count} :mate:\n"]
    end)

    Message.send(msg.channel_id, Enum.join(out))
  end


end