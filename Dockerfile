FROM elixir:1.9.4-alpine as mixer
ENV LANG=C.UTF-8
ENV MIX_ENV=prod

# Install needed packages
RUN apk update && apk add nodejs npm

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


FROM alpine  
ENV LANG=C.UTF-8

# Install openssl
RUN apk update && apk add openssl ncurses-libs

ENV MIX_ENV=prod
ENV PORT=4000

RUN mkdir /app
WORKDIR /app

# copy the release folder from the previous build
COPY --from=mixer /rel ./
RUN chown -R nobody: ./

EXPOSE ${PORT}
ENTRYPOINT ["./bin/hello_world_ci", "start"]
