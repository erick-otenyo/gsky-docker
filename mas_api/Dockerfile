FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net"

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
      postgresql-client

COPY ./scripts/build_webhook.sh /
RUN ./build_webhook.sh

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

ARG gsky_repo
ARG gsky_branch

COPY ./scripts/build_gsky.sh /
RUN ./build_gsky.sh

COPY ./scripts/ingest.sh /
COPY ./scripts/ingest_data.sh /
COPY ./scripts/reset_mas.sh /
COPY ./scripts/shard_delete.sh /


COPY ./hooks.yaml /hooks.yaml

COPY ./entrypoint.sh /

ENV TZ=Africa/Nairobi

EXPOSE 8888

ENTRYPOINT /wait && ./entrypoint.sh