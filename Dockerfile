FROM docker-registry.rewe-digital.com/rewe-go

COPY ./views    /var/service/server/views
COPY ./hackplan           /var/service/hackplan

WORKDIR /var/service

ENTRYPOINT ["/var/service/hackplan"]
