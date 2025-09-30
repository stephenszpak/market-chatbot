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

