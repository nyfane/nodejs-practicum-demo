FROM node:24-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev

COPY --chown=node:node src ./src

ARG APP_VERSION=local
ENV APP_VERSION=${APP_VERSION}
ENV NODE_ENV=production
ENV PORT=3000

USER node

EXPOSE 3000

CMD ["node", "src/server.js"]