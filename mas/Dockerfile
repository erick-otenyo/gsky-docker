FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

COPY ./scripts/build_pgsql.sh /
RUN ./build_pgsql.sh

COPY ./scripts/build_postgis.sh /
RUN ./build_postgis.sh

COPY ./scripts/setup_mas.sh /
RUN ./setup_mas.sh

COPY ./scripts/ingest.sh /
COPY ./scripts/ingest_data.sh /

COPY ./hooks.conf /hooks.conf

COPY ./entrypoint.sh /

ENV TZ=Africa/Nairobi

EXPOSE 8888