FROM node:alpine as teamA
WORKDIR /myreact
COPY ./package*.json ./
RUN npm install
COPY ./ ./      
RUN npm run build

FROM mesosphere/aws-cli
COPY --from=teamA /myreact/build .


CMD ["s3", "sync", "./", "s3://my-cicd-react"]

