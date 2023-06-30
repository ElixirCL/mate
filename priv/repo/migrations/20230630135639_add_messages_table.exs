defmodule Mate.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def change do
    create table("messages") do
      add :message_id, :bigint, null: false
      add :channel_id, :bigint, null: false
      add :guild_id, :bigint, null: false
      add :message_type, :smallint, null: false # mate, command
      add :from_user_id, :bigint, null: false
      timestamps(updated_at: false)
    end

    create unique_index(:messages, [:message_id])
    create index(:messages, [:channel_id])
    create index(:messages, [:guild_id])
    create index(:messages, [:message_type])
    create index(:messages, [:from_user_id])

    alter table("mates") do
      add :message_id, :bigint, null: false, default: 0
    end

    create index(:mates, [:message_id])
  end
end
