FROM elixir:1.9.2 as mixer

ENV MIX_ENV=test
ENV PORT=4000

# COPY . /app
RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

# install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# compile dependencies
COPY config ./config/

# copy only elixir files to keep the cache
COPY lib ./lib/
COPY priv ./priv/

EXPOSE ${PORT}

ENTRYPOINT ["mix", "test"]
