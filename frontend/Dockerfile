FROM --platform=linux/amd64 node:8.12-jessie

WORKDIR /var/src/app/frontend
COPY package-lock.json .
COPY package.json .
RUN npm install
