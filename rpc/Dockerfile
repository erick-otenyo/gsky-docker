FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

COPY ./scripts/build_gsky.sh /
RUN ./build_gsky.sh

ENV TZ=Africa/Nairobi