# --- -base- ---
FROM node:lts-alpine as base

ENV NODE_ENV=production
ENV YARN_CACHE_FOLDER=./yarn_cache

WORKDIR /root/app

COPY ./package.json ./yarn.* ./

RUN yarn install --frozen-lockfile

# --- -build- ---
FROM base as build

COPY . .
RUN npm i -g nx
RUN nx run-many --target=build --all

# --- -deploy- ---
FROM build as deploy

WORKDIR /var/www/html
COPY --from=build ./dist/apps/nx-docker .

RUN yarn install --production

# --- --- ---
CMD ls -las /root/app && tail -f /dev/null
