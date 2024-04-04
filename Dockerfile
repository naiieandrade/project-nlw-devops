# Dependencies step
FROM node:20 AS dependencies
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install

# Build step
FROM dependencies AS build
WORKDIR /usr/src/app
COPY . .
RUN npm run build
RUN npm prune --prod

# Deploy step
FROM node:20-alpine3.19 AS deploy
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/package-lock.json ./package-lock.json
COPY --from=build /usr/src/app/prisma ./prisma
RUN npx prisma generate

EXPOSE 3333

CMD ["npm", "run", "start"]
#"npm", "run", "migrate";
# # Use a base image
# FROM node:20 AS base

# # Install pnpm globally
# RUN npm i -g pnpm

# # Dependencies stage to install all the npm packages
# FROM base AS dependencies
# WORKDIR /usr/src/app
# COPY package.json pnpm-lock.yaml ./
# RUN pnpm install

# # Build stage to build the application
# FROM base AS build
# WORKDIR /usr/src/app
# COPY . .
# COPY --from=dependencies /usr/src/app/node_modules ./node_modules
# RUN pnpm build
# RUN pnpm prune --prod

# # Final deployment stage
# FROM node:20-alpine3.19 AS deploy
# WORKDIR /usr/src/app

# # Install bash
# RUN apk add --no-cache bash

# # Install pnpm and prisma globally
# RUN npm i -g pnpm prisma

# # Copy necessary files from the build stage
# COPY --from=build /usr/src/app/dist ./dist
# COPY --from=build /usr/src/app/node_modules ./node_modules
# COPY --from=build /usr/src/app/package.json ./package.json
# COPY --from=build /usr/src/app/prisma ./prisma

# # Generate prisma client
# RUN pnpm prisma generate

# # Add wait-for-it script
# COPY wait-for-it.sh /wait-for-it.sh
# RUN chmod +x /wait-for-it.sh

# # Expose the port the app runs on
# EXPOSE 3333

# # Use wait-for-it.sh to wait for the database to be ready before starting the app
# CMD [ "/wait-for-it.sh", "postgres:5432", "--", "pnpm", "start" ]