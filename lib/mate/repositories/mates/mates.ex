defmodule Mate.Repositories.Mates do
  alias __MODULE__
  alias Mates.Commands
  alias Mates.Queries
  alias Mates.Structs

  @max_mates 5

  def max, do: @max_mates

  def send_mate(id: id, from: from, to: to, channel: channel, guild: guild, content: content) do
    give = Structs.Give.new(id, from, to, channel, guild, content)
    case Queries.mates_from_user_for_today_in_guild(give.from.id, give.guild, :count) do
      count when count < @max_mates -> case give.from.id == give.to.id do
        true -> {:error, :SAME_PERSON, give.from}
        false -> {:ok, Commands.create(give), count}
      end
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


    {month_start, month_end} = Queries.month_datetimes()
    month_sent = Queries.mates_from_user_in_guild(user, guild, month_start, month_end, :count)
    month_received = Queries.mates_to_user_in_guild(user, guild, month_start, month_end, :count)

    {year_start, year_end} = Queries.year_datetimes()
    year_sent = Queries.mates_from_user_in_guild(user, guild, year_start, year_end, :count)
    year_received = Queries.mates_to_user_in_guild(user, guild, year_start, year_end, :count)

    total_sent = Queries.total_mates_from_user_in_guild(user, guild)
    total_received = Queries.total_mates_to_user_in_guild(user, guild)

    params = [
      today: [sent: sent, left: left, received: received, hours: hours],
      week: [sent: week_sent, received: week_received],
      month: [sent: month_sent, received: month_received],
      year: [sent: year_sent, received: year_received],
      total: [sent: total_sent, received: total_received]
    ]

    Structs.Stats.new(params)
  end

  def top(guild, :week, take \\ 10) do

    {week_start, week_end} = Queries.week_datetimes()

    top_giving = Queries.top_giving_users_in_guild(guild, week_start, week_end, take)
    |> Enum.with_index()
    |> Enum.map(fn {record, index} ->
      Structs.TopUser.new(record.from_user_id, record.count, index)
    end)

    top_receiving = Queries.top_receiving_users_in_guild(guild, week_start, week_end, take)
    |> Enum.with_index()
    |> Enum.map(fn {record, index} ->
      Structs.TopUser.new(record.to_user_id, record.count, index)
    end)

    %{
      giving: top_giving,
      receiving: top_receiving,
      start_at: week_start,
      end_at: week_end
    }
  end

end