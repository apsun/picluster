FROM busybox:latest
ADD index.html /srv/www/index.html
EXPOSE 80
CMD ["httpd", "-f", "-h", "/srv/www"]
