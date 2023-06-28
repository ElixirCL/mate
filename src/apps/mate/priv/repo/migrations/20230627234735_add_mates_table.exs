defmodule Mate.Repo.Migrations.AddMatesTable do
  use Ecto.Migration

  def change do
    create table("mates") do
      add :from_user_id, :bigint
      add :to_user_id, :bigint
      add :channel_id, :bigint
      add :guild_id, :bigint
      timestamps()
    end
  end
end
