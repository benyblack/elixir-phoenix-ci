FROM elixir:1.9.2

RUN mkdir /app
WORKDIR /app
ENV MIX_ENV=prod

# Install needed packages
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get -y install curl inotify-tools nodejs

RUN mix local.hex --force
RUN mix local.rebar --force

# Install depencencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy needed files
COPY ./config ./config
COPY ./lib ./lib
COPY ./priv ./priv
COPY ./test ./test

# Build client-side stuff
COPY ./assets ./assets
RUN cd assets && npm install

# Final build
RUN cd assets && \
    npm run deploy && \
    cd .. && \
    mix do compile, phx.digest

EXPOSE ${PORT}
ENTRYPOINT ["mix", "phx.server"]
