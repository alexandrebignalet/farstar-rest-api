FROM nitlang/nit

RUN apt-get update && apt-get install inotify-tools gettext libevent-dev \
    libsqlite3-dev ccache -y

WORKDIR /nit/contrib/far_star_rest_api/server

EXPOSE 8080
