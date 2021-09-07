FROM node:alpine

RUN apk update
RUN apk add scp 
RUN apk add --update --no-cache sshpass
RUN apk add --update nodejs npm

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . ./
CMD ["npm", "start"]

