FROM alpine:3.12
LABEL maintainer="Pujan Shah"
ARG VERSION="2.81-r0"
RUN apk --no-cache add dnsmasq=$VERSION
USER nobody
VOLUME /etc/dnsmasq.d/
EXPOSE 8053 8053/udp
ENTRYPOINT ["dnsmasq"]
CMD ["-p8053", "-k", "--log-facility=-"]
HEALTHCHECK --interval=10s CMD ["dnsmasq", "--test"]
