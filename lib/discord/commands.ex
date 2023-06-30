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

  def handle(:top, _msg) do

  end


end