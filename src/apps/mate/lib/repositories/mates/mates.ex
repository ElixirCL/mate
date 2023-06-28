defmodule Mate.Repositories.Mates do
  alias __MODULE__
  alias Mates.Commands
  alias Mates.Queries
  alias Mates.Structs

  @max_mates 5

  def send_mate(from: from, to: to, channel: channel, guild: guild, content: content) do
    give = Structs.Give.new(from, to, channel, guild, content)
    case Queries.mates_from_user_for_today_in_guild(give.from.id, give.guild, :count) do
      count when count < @max_mates -> {:ok, Commands.create(give), count}
      count -> {:error, :MAX_MATES_PER_DAY_REACHED, count}
    end
  end
end