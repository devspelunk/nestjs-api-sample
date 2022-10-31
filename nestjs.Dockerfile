FROM node:19.0.0-alpine3.15 AS development

# Set node environment
ARG NODE_ENV=development
ENV NODE_ENV $NODE_ENV

# Get latest npm version for fixes. Pin version on final.
RUN npm i npm@latest -g

# Create a different location for easier app bind mount for local development.
RUN mkdir /opt/node_app && chown node:node /opt/node_app
WORKDIR /opt/node_app

# Unprivledged user for security
USER node
COPY --chown=node:node ./nestjs-api/package*.json ./
RUN npm ci && npm cache clean --force
ENV PATH /opt/node_app/node_modules/.bin:$PATH

# Copy in source code
WORKDIR /opt/node_app/app
COPY --chown=node:node ./nestjs-api .

RUN npm run build

FROM node:19.0.0-alpine3.15 AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY ./nestjs-api/package*.json ./

RUN npm install --only=production

COPY ./nestjs-api .

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]