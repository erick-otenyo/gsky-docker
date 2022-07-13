FROM debian:bookworm-slim
LABEL maintainer="Erick Otenyo <eotenyo@icpac.net" 

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        ca-certificates libreadline-dev cmake openssl curl wget git bc \
        pkg-config unzip autoconf automake libtool build-essential bison flex vim less

COPY ./build_deps.sh /
RUN ./build_deps.sh

COPY ./build_deps_2.sh /
RUN ./build_deps_2.sh

COPY ./build_gdal.sh /
RUN ./build_gdal.sh

COPY ./build_go.sh /
RUN ./build_go.sh

ENV PATH $PATH:/usr/local/go/bin