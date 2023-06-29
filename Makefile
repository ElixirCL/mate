.PHONY: phx.db.setup phx.server phx.assets.deploy phx.release.docker fly.launch fly.deploy fly.secret fly.db

# Set the corresponding Discord Token and DATABASE_URL
# in env
DISCORD_TOKEN=
DATABASE_URL=
# cd src && mix phx.gen.secret
SECRET_KEY_BASE=


phx.server s:
	cd src && DISCORD_TOKEN=$DISCORD_TOKEN iex -S mix phx.server

phx.db.setup dbs:
	cd src && mix ecto.drop
	cd src && mix ecto.create
	cd src && mix ecto.migrate

phx.assets.deploy ad:
	cd src/apps/mate_web && MIX_ENV=prod mix assets.deploy

phx.release.docker r:
	cd src/apps/mate_web && mix phx.gen.release --docker

fly.launch fl:
	cd src/ && fly launch --name elixircl-matebot --build-only --no-deploy --dockerfile Dockerfile --dockerignore-from-gitignore --region scl

fly.deploy fd:
	cd src/ && fly deploy

fly.secret fs:
	cd src && fly secrets set SECRET_KEY_BASE=${SECRET_KEY_BASE}
	cd src && fly secrets set DISCORD_TOKEN=${DISCORD_TOKEN}
	cd src && fly secrets set DATABASE_URL=${DATABASE_URL}

fly.db fdb:
	cd src && fly postgres create --name elixircl-matebot-db --region scl
	fly postgres -a elixircl-matebot-db db list