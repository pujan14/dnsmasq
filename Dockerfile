FROM alpine:latest

RUN apk --no-cache add dnsmasq

VOLUME /etc/dnsmasq.d/

EXPOSE 53 53/udp

ENTRYPOINT ["dnsmasq", "-k"]
