FROM gcc:10 as build
ARG VERSION="2.82"
RUN gpg --keyserver keyring.debian.org --recv 15CDDA6AE19135A2
RUN wget http://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz
RUN wget http://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz.asc
RUN gpg --verify dnsmasq-$VERSION.tar.gz.asc dnsmasq-$VERSION.tar.gz && tar -xzf dnsmasq-$VERSION.tar.gz
WORKDIR /dnsmasq-$VERSION
RUN make install

FROM gcr.io/distroless/base-debian10:nonroot
LABEL maintainer="Pujan Shah"
COPY --from=build /usr/local/sbin/dnsmasq /usr/local/sbin/dnsmasq
USER nonroot
VOLUME /etc/dnsmasq.d/
EXPOSE 8053 8053/udp
ENTRYPOINT ["dnsmasq"]
CMD ["-p8053", "-k", "--log-facility=-"]
HEALTHCHECK --interval=10s CMD ["dnsmasq", "--test"]
