FROM alpine:latest
RUN apk --no-cache add dnsmasq
VOLUME /etc/dnsmasq.d/
EXPOSE 53 53/udp 67/udp
ENTRYPOINT ["dnsmasq", "-k", "--log-facility=-"]
HEALTHCHECK --interval=10s CMD pgrep dnsmasq
