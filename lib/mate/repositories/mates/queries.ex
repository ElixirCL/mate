defmodule Mate.Repositories.Mates.Queries do
    import Ecto.Query, warn: false
    alias Mate.Repo
    alias Mate.Repositories.Mates.Schema, as: Mate

    @time_start_at ~T[00:00:00.000]
    @time_end_at ~T[23:59:59.999]

    def today_datetimes() do
      today = NaiveDateTime.utc_now()
              |> NaiveDateTime.to_date()

      start_at = NaiveDateTime.new!(today, @time_start_at)
      end_at = NaiveDateTime.new!(today, @time_end_at)
      today_at = NaiveDateTime.new!(today,
              NaiveDateTime.utc_now()
              |> NaiveDateTime.to_time())

      seconds_until_tomorrow = NaiveDateTime.diff(end_at, today_at)

      {today_at, start_at, end_at, seconds_until_tomorrow}
    end

    def week_datetimes() do
      today = NaiveDateTime.utc_now()
              |> NaiveDateTime.to_date()

      start_at = NaiveDateTime.new!(Date.beginning_of_week(today), @time_start_at)
      end_at = NaiveDateTime.new!(Date.end_of_week(today), @time_end_at)

      {start_at, end_at}
    end

    def month_datetimes() do
      today = NaiveDateTime.utc_now()
              |> NaiveDateTime.to_date()

      start_at = NaiveDateTime.new!(Date.beginning_of_month(today), @time_start_at)
      end_at = NaiveDateTime.new!(Date.end_of_month(today), @time_end_at)

      {start_at, end_at}
    end

    def year_datetimes() do
      year = DateTime.utc_now().year

      start_at = NaiveDateTime.new!(Date.new!(year, 1, 1), @time_start_at)
      end_at = NaiveDateTime.new!(Date.new!(year, 12, 12), @time_end_at)

      {start_at, end_at}
    end

    # MARK: From User
    defp mates_from_user_query(user_id, start_at, end_at) do
      from(m in Mate,
        where: m.from_user_id == ^user_id and
               m.inserted_at >= ^start_at and
               m.inserted_at <= ^end_at,
        order_by: [desc: m.inserted_at]
      )
    end

    defp mates_from_user_in_guild_query(user_id, guild_id, start_at, end_at) do
      from(m in Mate,
        where: m.from_user_id == ^user_id and
               m.guild_id == ^guild_id and
               m.inserted_at >= ^start_at and
               m.inserted_at <= ^end_at,
        order_by: [desc: m.inserted_at]
      )
    end

    defp total_mates_from_user_in_guild_query(user_id, guild_id) do
      from(m in Mate,
        where: m.from_user_id == ^user_id and
               m.guild_id == ^guild_id,
        order_by: [desc: m.inserted_at]
      )
    end

    # MARK: To User
    defp mates_to_user_query(user_id, start_at, end_at) do
      from(m in Mate,
        where: m.to_user_id == ^user_id and
               m.inserted_at >= ^start_at and
               m.inserted_at <= ^end_at,
        order_by: [desc: m.inserted_at]
      )
    end

    defp mates_to_user_in_guild_query(user_id, guild_id, start_at, end_at) do
      from(m in Mate,
        where: m.to_user_id == ^user_id and
               m.guild_id == ^guild_id and
               m.inserted_at >= ^start_at and
               m.inserted_at <= ^end_at,
        order_by: [desc: m.inserted_at]
      )
    end

    defp total_mates_to_user_in_guild_query(user_id, guild_id) do
      from(m in Mate,
        where: m.to_user_id == ^user_id and
               m.guild_id == ^guild_id,
        order_by: [desc: m.inserted_at]
      )
    end

    # From User
    def mates_from_user(user_id, start_at, end_at) do
      mates_from_user_query(user_id, start_at, end_at)
      |> Repo.all()
    end

    def mates_from_user(user_id, start_at, end_at, :count) do
      mates_from_user_query(user_id, start_at, end_at)
      |> Repo.aggregate(:count, :id)
    end

    def mates_from_user_in_guild(user_id, guild_id, start_at, end_at) do
      mates_from_user_in_guild_query(user_id, guild_id, start_at, end_at)
      |> Repo.all()
    end

    def mates_from_user_in_guild(user_id, guild_id, start_at, end_at, :count) do
      mates_from_user_in_guild_query(user_id, guild_id, start_at, end_at)
      |> Repo.aggregate(:count, :id)
    end

    def total_mates_from_user_in_guild(user_id, guild_id) do
      total_mates_from_user_in_guild_query(user_id, guild_id)
      |> Repo.aggregate(:count, :id)
    end

    def mates_from_user_for_today(user_id) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_from_user(user_id, start_at, end_at)
    end

    def mates_from_user_for_today(user_id, :count) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_from_user(user_id, start_at, end_at, :count)
    end

    def mates_from_user_for_today_in_guild(user_id, guild_id) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_from_user_in_guild(user_id, guild_id, start_at, end_at)
    end

    def mates_from_user_for_today_in_guild(user_id, guild_id, :count) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_from_user_in_guild(user_id, guild_id, start_at, end_at, :count)
    end

    # To User
    def mates_to_user(user_id, start_at, end_at) do
      mates_to_user_query(user_id, start_at, end_at)
      |> Repo.all()
    end

    def mates_to_user(user_id, start_at, end_at, :count) do
      mates_to_user_query(user_id, start_at, end_at)
      |> Repo.aggregate(:count, :id)
    end

    def mates_to_user_in_guild(user_id, guild_id, start_at, end_at) do
      mates_to_user_in_guild_query(user_id, guild_id, start_at, end_at)
      |> Repo.all()
    end

    def mates_to_user_in_guild(user_id, guild_id, start_at, end_at, :count) do
      mates_to_user_in_guild_query(user_id, guild_id, start_at, end_at)
      |> Repo.aggregate(:count, :id)
    end

    def total_mates_to_user_in_guild(user_id, guild_id) do
      total_mates_to_user_in_guild_query(user_id, guild_id)
      |> Repo.aggregate(:count, :id)
    end

    def mates_to_user_for_today(user_id) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_to_user(user_id, start_at, end_at)
    end

    def mates_to_user_for_today(user_id, :count) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_to_user(user_id, start_at, end_at, :count)
    end

    def mates_to_user_for_today_in_guild(user_id, guild_id) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_to_user_in_guild(user_id, guild_id, start_at, end_at)
    end

    def mates_to_user_for_today_in_guild(user_id, guild_id, :count) do
      {_, start_at, end_at, _} = today_datetimes()
      mates_to_user_in_guild(user_id, guild_id, start_at, end_at, :count)
    end
end