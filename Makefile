.PHONY: deps db.setup phx.server fly.launch fly.deploy fly.db.list
FLY_APP_NAME=elixircl-matebot
FLY_REGION=scl

deps d:
	mix deps.get

db.setup dbs:
	mix ecto.drop
	mix ecto.create
	mix ecto.migrate

db.run dbr:
	postgres -D /usr/local/var/postgres

phx.server ps:
	iex -S mix phx.server

fly.launch fl:
	fly launch --name ${FLY_APP_NAME} --dockerignore-from-gitignore --region ${FLY_REGION}

fly.deploy fd:
	fly deploy

fly.db.list fdl:
	fly postgres -a ${FLY_APP_NAME} db list