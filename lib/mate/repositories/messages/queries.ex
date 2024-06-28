defmodule Mate.Repositories.Messages.Queries do
  import Ecto.Query, warn: false
  alias Mate.Repo
  alias Mate.Repositories.Messages.Schema, as: Message

  defp get_query(message_id) do
    from(m in Message,
      where: m.message_id == ^message_id,
      order_by: [desc: m.inserted_at]
    )
  end

  def get(message_id) do
    get_query(message_id)
    |> Repo.one()
  end

  def get(message_id, :count) do
    get_query(message_id)
    |> Repo.aggregate(:count, :id)
  end

  def get_last_message() do
    Message
    |> last()
    |> Repo.one()
  end
end
