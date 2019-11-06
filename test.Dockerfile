FROM elixir:1.9.2 as mixer

ENV MIX_ENV=test
ENV PORT=4000

# COPY . /app
RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

COPY config ./config/
COPY lib ./lib/
COPY priv ./priv/
COPY test ./priv/

# install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

RUN mix do compile

ENTRYPOINT ["mix", "test"]