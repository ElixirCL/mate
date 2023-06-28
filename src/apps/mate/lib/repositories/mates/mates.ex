defmodule Mate.Repositories.Mates do
  alias __MODULE__
  alias Mates.Commands
  alias Mates.Queries
  alias Mates.Structs

  @max_mates 5

  def max, do: @max_mates

  def send_mate(from: from, to: to, channel: channel, guild: guild, content: content) do
    give = Structs.Give.new(from, to, channel, guild, content)
    case Queries.mates_from_user_for_today_in_guild(give.from.id, give.guild, :count) do
      count when count < @max_mates -> {:ok, Commands.create(give), count}
      count -> {:error, :MAX_MATES_PER_DAY_REACHED, count}
    end
  end

  def stats(user: user, guild: guild) do
    sent = Queries.mates_from_user_for_today_in_guild(user, guild, :count)
    left = @max_mates - sent

    received = Queries.mates_to_user_for_today_in_guild(user, guild, :count)

    {_today, _start, _end, seconds_until_tomorrow} = Queries.today_datetimes()
    hours = floor(seconds_until_tomorrow / 60 / 60)

    {week_start, week_end} = Queries.week_datetimes()

    week_sent = Queries.mates_from_user_in_guild(user, guild, week_start, week_end, :count)
    week_received = Queries.mates_to_user_in_guild(user, guild, week_start, week_end, :count)

    total_sent = Queries.total_mates_from_user_in_guild(user, guild)
    total_received = Queries.total_mates_to_user_in_guild(user, guild)

    params = [
      today: [sent: sent, left: left, received: received, hours: hours],
      week: [sent: week_sent, received: week_received],
      total: [sent: total_sent, received: total_received]
    ]

    Structs.Stats.new(params)
  end

end