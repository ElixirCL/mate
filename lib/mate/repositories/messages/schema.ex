defmodule Mate.Repositories.Messages.Schema do
  use Mate.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message_id, :integer
    field :from_user_id, :integer
    field :message_type, :integer
    field :channel_id, :integer
    field :guild_id, :integer
    timestamps(updated_at: false)
  end

  @optional []
  @required [:message_id, :from_user_id, :message_type, :channel_id, :guild_id]

  def changeset(model, attrs) do
    model
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> unique_constraint(:message_id, name: :messages_message_id_index)
  end


end