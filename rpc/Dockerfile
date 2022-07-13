FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

COPY ./scripts/build_gsky_ows.sh /
RUN ./build_gsky_ows.sh

ENV TZ=Africa/Nairobi