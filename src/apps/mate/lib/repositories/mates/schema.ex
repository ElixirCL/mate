defmodule Mate.Repositories.Mates.Schema do
  use Mate.Schema
  import Ecto.Changeset

  schema "mates" do
    field :from_user_id, :integer
    field :from_user_name, :string
    field :to_user_id, :integer
    field :to_user_name, :string
    field :channel_id, :integer
    field :guild_id, :integer
    timestamps(updated_at: false)
  end

  @optional []
  @required [:from_user_id, :from_user_name, :to_user_id, :to_user_name, :channel_id, :guild_id]

  def changeset(model, attrs) do
    model
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
  end
end