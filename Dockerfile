FROM gcc:latest as build
ARG VERSION="2.82"
RUN gpg --keyserver keyring.debian.org --recv 15CDDA6AE19135A2
RUN wget http://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz
RUN wget http://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz.asc
RUN gpg --verify dnsmasq-$VERSION.tar.gz.asc dnsmasq-$VERSION.tar.gz && tar -xzf dnsmasq-$VERSION.tar.gz
RUN cd dnsmasq-$VERSION && make install

FROM gcr.io/distroless/base-debian10
COPY --from=build /usr/local/sbin/dnsmasq /

VOLUME /etc/dnsmasq.d/

EXPOSE 53 53/udp 67/udp

ENTRYPOINT ["/dnsmasq", "-k", "--log-facility=-"]

HEALTHCHECK --interval=10s CMD dnsmasq --test
