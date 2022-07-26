FROM node:14.7-alpine

RUN apk -U upgrade \
    && apk add --no-cache \
    git

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

# Create app directory
WORKDIR /usr/src/app

# Clone repo
RUN git clone https://github.com/icpac-igad/gsky-wps-api.git /usr/src/app

RUN yarn install --production

COPY ./entrypoint.sh /

EXPOSE 3000

ENTRYPOINT /wait && yarn start