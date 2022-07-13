FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

COPY ./scripts/build_gsky.sh /
RUN ./build_gsky.sh

COPY ./scripts/build_webhook.sh /
RUN ./build_webhook.sh

COPY ./scripts/reload_ows_config.sh /

COPY ./hooks.conf /hooks.conf

ENV TZ=Africa/Nairobi