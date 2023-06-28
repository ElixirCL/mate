defmodule Mate.Repo.Migrations.AddMatesTable do
  use Ecto.Migration

  def change do
    create table("mates") do
      add :from_user_id, :bigint, null: false
      add :from_user_name, :string, null: false
      add :to_user_id, :bigint, null: false
      add :to_user_name, :string, null: false
      add :channel_id, :bigint, null: false
      add :guild_id, :bigint, null: false
      timestamps(updated_at: false)
    end

    create index(:mates, [:from_user_id])
    create index(:mates, [:to_user_id])
    create index(:mates, [:from_user_name])
    create index(:mates, [:to_user_name])
    create index(:mates, [:channel_id])
    create index(:mates, [:guild_id])
  end
end
