FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /tmp/dist
RUN d=$(dirname $(find /tmp/dist -name index.html | head -n1)) && cp -r $d/. /usr/share/nginx/html/
