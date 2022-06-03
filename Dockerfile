FROM node:14

MAINTAINER Matthew Lorentz <matt@planetary.social>

USER root
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /tini
RUN chmod +x /tini
RUN mkdir /home/node/.npm-global ; \
    chown -R node:node /home/node/
ENV PATH=/home/node/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

USER node
WORKDIR /home/node
COPY . .
RUN npm ci --only=production

EXPOSE 8008

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=10 \
  CMD ssb-server whoami || exit 1
ENV HEALING_ACTION RESTART

CMD [ "/tini", "--", "node", "index.js" ]
