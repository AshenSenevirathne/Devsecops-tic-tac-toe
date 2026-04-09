FROM node:20-alpine AS build

# Install dependencies and build the app in a lightweight Node image.
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27.5-alpine

RUN apk update && apk upgrade --no-cache

# Serve the compiled static files with nginx.
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]