FROM eahazardswatch.icpac.net/gsky-base:latest
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

COPY ./scripts/build_gsky.sh /
RUN ./build_gsky.sh

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

COPY ./entrypoint.sh /

ENV TZ=Africa/Nairobi

ENTRYPOINT /wait && ./entrypoint.sh