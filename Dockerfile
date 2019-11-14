FROM kong

COPY ./external-auth /usr/local/share/lua/5.1/kong/plugins/external-auth
COPY ./ssl /etc/ssl/
RUN cp /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.pem
