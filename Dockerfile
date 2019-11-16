FROM elixir:1.9.4 as mixer
ENV LANG=C.UTF-8
ENV MIX_ENV=prod

# Install needed packages
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get -y install nodejs openssl

RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

# install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN cd assets && npm install

# build assets
COPY assets ./assets/
RUN cd assets && npm run deploy

# copy only needed files
COPY config ./config/
COPY lib ./lib/
COPY priv ./priv/

# compile
RUN mix do compile
RUN mix phx.digest

# make release
RUN mkdir /rel
RUN mix release --path /rel

# if you would like to use alpine image, you have to install some needed packages
# I use debian:stretch to avoid additional package install
FROM debian:stretch
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y openssl

ENV MIX_ENV=prod
ENV PORT=4000

RUN mkdir /app
WORKDIR /app

# copy the release folder from the previous build
COPY --from=mixer /rel ./
RUN chown -R nobody: ./

EXPOSE ${PORT}
ENTRYPOINT ["./bin/hello_world_ci", "start"]
