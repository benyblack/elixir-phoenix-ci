FROM elixir:1.9.2 as mixer

ENV MIX_ENV=dev

RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

# install dependencies, needed for frontend part
COPY mix.exs mix.lock ./
RUN mix deps.get


FROM node:12.13.0-alpine as build-node

# prepare build dir
RUN mkdir -p /app/assets
WORKDIR /app

# set build ENV
ENV NODE_ENV=dev

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
COPY --from=mixer /app/deps/phoenix deps/phoenix
COPY --from=mixer /app/deps/phoenix_html deps/phoenix_html
RUN cd assets && npm install

# build assets
COPY assets ./assets/
RUN cd assets && npm run deploy

FROM elixir:1.9.2

LABEL authur=benyblack

ENV MIX_ENV=dev
ENV PORT=4000

# COPY . /app
RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get install -y inotify-tools


COPY mix.exs mix.lock ./
# instead of installing deps, get it from prev build
COPY --from=mixer /app/deps/ deps/

# compile dependencies
COPY config ./config/

# copy only elixir files to keep the cache
COPY lib ./lib/
COPY priv ./priv/

# copy assets from node build
COPY --from=build-node /app/priv/static ./priv/static
RUN mix phx.digest

EXPOSE ${PORT}

ENTRYPOINT ["mix", "phx.server"]
