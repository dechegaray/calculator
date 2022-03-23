FROM node:14-alpine AS builder
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
COPY package.json yarn.lock /app/
WORKDIR /app
RUN yarn --frozen-lockfile

# Copy the source
COPY . /app/
RUN yarn build

FROM nginx:stable-alpine

RUN apk update
RUN apk upgrade
RUN apk add bash

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/build .

ENTRYPOINT ["nginx", "-g", "daemon off;"]