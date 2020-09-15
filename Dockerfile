FROM gcc:latest as build
ARG VERSION="v2.82"
RUN git -c advice.detachedHead=false clone -q -b $VERSION git://thekelleys.org.uk/dnsmasq.git dnsmasq
RUN cd dnsmasq && make install

FROM gcr.io/distroless/base-debian10
COPY --from=build /usr/local/sbin/dnsmasq /

VOLUME /etc/dnsmasq.d/

EXPOSE 53 53/udp 67/udp

ENTRYPOINT ["dnsmasq", "-k", "--log-facility=-"]

HEALTHCHECK --interval=10s CMD dnsmasq --test
