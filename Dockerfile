FROM node:16.16.0-alpine 

WORKDIR "/var/app"

COPY package.json .

RUN npm run build

COPY . .

CMD [ "npm" , "start" ]
