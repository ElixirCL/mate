.PHONY: db.setup server

server s:
	cd src && DISCORD_TOKEN="" iex -S mix phx.server

db.setup dbs:
	cd src && mix ecto.drop
	cd src && mix ecto.create
	cd src && mix ecto.migrate