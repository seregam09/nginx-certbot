#!/bin/bash

SSL_ON=$1
DN=`cat ${PWD}/.env | grep DOMAIN_NAME | cut -d'=' -f2`


echo "server {
    server_name ${DN} www.${DN};
    listen 80;
    root /public_html;

    # Letsencrypt velidation
    location ^~ /.well-known/acme-challenge/ {
        allow all;
        root /var/www/certbot;
    }

}
" > ./data/conf.d/${DN}.conf


if [ "SSl_ON" = "ssl" ]
then
    echo "server {
    server_name ${DN} www.${DN};
    listen 80;
    root /public_html;

    # Letsencrypt velidation
    location ^~ /.well-known/acme-challenge/ {
        allow all;
        root /var/www/certbot;
    }
    # Redirect http to https
    location / {
        return 301 https://${DN}\$request_uri;
    }
}

server {
    server_name ${DN} www.${DN};
    listen 443 ssl http2;
    root /public_html;

    ssl on;
    ssl_certificate     /etc/nginx/ssl/live/${DN}/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/${DN}/privkey.pem;
    ssl_dhparam         /etc/nginx/ssl/ssl-dhparams.pem;

    include /etc/nginx/ssl/options-ssl-nginx.conf;
    
    location / {
        index index.html;
    }
}
" > ./data/conf.d/${DN}.conf

docker exec -d web_nginx nginx -s reload

fi