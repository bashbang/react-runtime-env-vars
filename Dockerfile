#############################################################################################
###                                 BUILD IMAGE                                      ###
#############################################################################################
FROM node:14-alpine as build

RUN apk add --update npm

COPY ./package.json ./yarn.lock ./

ENV NODE_ENV=production

RUN npm install

COPY . .

RUN npm run build

#############################################################################################
###                                 PRODUCTION IMAGE                                      ###
#############################################################################################
FROM nginx:1.19-alpine

RUN rm -rf /usr/share/nginx/html/
COPY --from=build build /etc/nginx/html/cmf-ui

WORKDIR /etc/nginx/html/cmf-ui

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# This is used to generate a env-config.js file used at runtime - see env.sh for further details
COPY ./env.sh .
COPY .env.template .env

# CMD ["nginx", "-g", "daemon off;"]
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
RUN chmod g+rwx /etc/nginx/html/cmf-ui

# Add bash
RUN apk add --no-cache bash

# Make our shell script executable
RUN chmod g+rwx env.sh

CMD ["/bin/bash", "-c", "/etc/nginx/html/cmf-ui/env.sh && nginx -g \"daemon off;\""]