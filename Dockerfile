FROM node:alpine as teamA
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
COPY ./ ./      
RUN npm run build


FROM nginx
EXPOSE 80
COPY --from=teamA /usr/app/build /usr/share/nginx/html

CMD ["s3", "sync", "./", "s3://myreact-cicd"] 
