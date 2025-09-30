# Multi-stage build: widget -> app build -> release runner

# 1) Build the React widget with Vite
FROM node:20-alpine AS widget_builder
WORKDIR /build/widget
COPY assets/widget/package*.json ./
COPY assets/widget/vite.config.ts ./vite.config.ts
COPY assets/widget/tsconfig.json ./tsconfig.json
COPY assets/widget/src ./src
RUN npm ci || npm install
RUN npm run build

# 2) Build the Elixir/Phoenix app and produce a release
FROM hexpm/elixir:1.15.7-erlang-26.2.5-debian-bookworm-20240423 AS app_builder
ENV MIX_ENV=prod
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git \
  && rm -rf /var/lib/apt/lists/*

# Install Hex/Rebar and fetch deps (use cached layers)
COPY mix.exs ./
COPY mix.lock* ./
COPY config ./config
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only prod

# Copy app code
COPY lib ./lib

# Copy built widget into Phoenix static directory
RUN mkdir -p priv/static/ab_widget
COPY --from=widget_builder /build/widget/dist/ ./priv/static/ab_widget/

# Copy fonts into Phoenix static directory
RUN mkdir -p priv/static/fonts
COPY assets/fonts/ ./priv/static/fonts/

# Compile and build release
RUN mix compile
RUN mix release

# 3) Runtime image
FROM debian:bookworm-slim AS runner
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl libstdc++6 ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd --create-home --system --user-group app
USER app

# Copy release
COPY --from=app_builder /app/_build/prod/rel/app ./rel/app

ENV MIX_ENV=prod \
    LANG=C.UTF-8 \
    PORT=4000 \
    PHX_SERVER=true

EXPOSE 4000

# Secret must be provided at runtime (or baked for demo)
# e.g. docker run -e SECRET_KEY_BASE=... -p 4000:4000 image
CMD ["./rel/app/bin/app", "start"]

# 4) Optional: Dev target for simple local runs (no hot-reload)
FROM hexpm/elixir:1.15.7-erlang-26.2.5-debian-bookworm-20240423 AS dev
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends git curl inotify-tools build-essential \
  && rm -rf /var/lib/apt/lists/*
# Add Node.js from official image for building widget
COPY --from=node:20-bullseye /usr/local /usr/local
ENV PATH=/usr/local/bin:$PATH \
    MIX_ENV=dev

COPY . .
RUN mix local.hex --force && mix local.rebar --force && mix deps.get

ENV SECRET_KEY_BASE=devsecretdevsecretdevsecretdevsecretdevsecretdevsecret12 \
    PORT=4000
EXPOSE 4000
CMD ["./bin/dev"]
