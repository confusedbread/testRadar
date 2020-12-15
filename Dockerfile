FROM node:10.15.3 as source
WORKDIR /src/build-your-own-radar
COPY package.json ./
RUN npm install
COPY . ./
RUN npm run build

FROM nginx:1.15.9
WORKDIR /opt/build-your-own-radar
COPY --from=source /src/build-your-own-radar/dist .
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
COPY default.template /etc/nginx/conf.d/default.conf
RUN addgroup nginx root
USER nginx
#CMD ["nginx", "-g", "daemon off;"]