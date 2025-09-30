APP_NAME=ab-insights-assistant

.PHONY: help
help:
	@echo "Common targets:"
	@echo "  make dev            # docker compose up with hot reload"
	@echo "  make down           # stop dev containers"
	@echo "  make logs           # tail logs"
	@echo "  make sh             # shell into dev container"
	@echo "  make build          # build prod image"
	@echo "  make run            # run prod image (random SECRET_KEY_BASE)"
	@echo "  make widget-build   # build widget locally"
	@echo "  make phx            # run Phoenix locally (requires deps)"
	@echo "  make seed           # run DB seeds inside dev container"
	@echo "  make seed-local     # run DB seeds locally"
	@echo "  make deps           # mix deps.get in dev container"
	@echo "  make deps-update    # mix deps.update --all in dev container"
	@echo "  make compile        # mix compile in dev container"
	@echo "  make ecto-create    # mix ecto.create in dev container"
	@echo "  make ecto-migrate   # mix ecto.migrate in dev container"
	@echo "  make ecto-rollback  # mix ecto.rollback in dev container"
	@echo "  make ecto-setup     # mix ecto.setup in dev container"
	@echo "  make ecto-reset     # mix ecto.reset in dev container"

.PHONY: dev
dev:
	docker compose up --build

.PHONY: down
down:
	docker compose down

.PHONY: logs
logs:
	docker compose logs -f

.PHONY: sh
sh:
	docker compose exec web bash || docker compose run --rm web bash

.PHONY: build
build:
	docker build -t $(APP_NAME):latest .

.PHONY: run
run:
	@SECRET=$$(openssl rand -hex 64); \
		echo "Using generated SECRET_KEY_BASE: $$SECRET"; \
		docker run --rm -e SECRET_KEY_BASE=$$SECRET -e PORT=4000 -p 4000:4000 $(APP_NAME):latest

.PHONY: widget-build
widget-build:
	cd assets/widget && npm install && npm run build

.PHONY: phx
phx:
	mix deps.get && mix phx.server

.PHONY: seed
seed:
	docker compose exec web mix run priv/repo/seeds.exs

.PHONY: seed-local
seed-local:
	mix run priv/repo/seeds.exs

.PHONY: deps
deps:
	docker compose exec web mix deps.get

.PHONY: deps-update
deps-update:
	docker compose exec web mix deps.update --all

.PHONY: compile
compile:
	docker compose exec web mix compile

.PHONY: ecto-create
ecto-create:
	docker compose exec web sh -lc 'mkdir -p priv/repo/migrations && mix ecto.create'

.PHONY: ecto-migrate
ecto-migrate:
	docker compose exec web sh -lc 'mkdir -p priv/repo/migrations && mix ecto.migrate'

.PHONY: ecto-rollback
ecto-rollback:
	docker compose exec web sh -lc 'mkdir -p priv/repo/migrations && mix ecto.rollback'

.PHONY: ecto-setup
ecto-setup:
	docker compose exec web sh -lc 'mkdir -p priv/repo/migrations && mix ecto.setup'

.PHONY: ecto-reset
ecto-reset:
	docker compose exec web sh -lc 'mkdir -p priv/repo/migrations && mix ecto.reset'
