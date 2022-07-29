FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
      jq

COPY ./scripts/build_webhook.sh /
RUN ./build_webhook.sh

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

COPY ./scripts/build_gsky.sh /
RUN ./build_gsky.sh

COPY ./scripts/reload_ows_config.sh /

COPY ./hooks.yaml /hooks.yaml

COPY ./entrypoint.sh /

ENV TZ=Africa/Nairobi

ENTRYPOINT /wait && ./entrypoint.sh