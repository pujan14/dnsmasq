# For security and reliability use sha256 checksums for pinning, tags are mutable
# Add comment for docker tag for future reference alpine:3.12
FROM alpine@sha256:90baa0922fe90624b05cb5766fa5da4e337921656c2f8e2b13bd3c052a0baac1
# Do not use maintainer command, it's deprecated
LABEL maintainer="Pujan Shah"
# Install specific version
ARG VERSION="2.81-r0"
# Use the --no-cache to avoid using cache which should be removed later on
RUN apk --no-cache add dnsmasq=$VERSION
# Switch to nonroot or nobody user whenever possible in runtime images
USER nobody
# nonroot user can only use ports higher than 1024
VOLUME /etc/dnsmasq.d/
# nonroot user can only use ports higher than 1024
EXPOSE 8053 8053/udp
# Specify both ENTRYPOINT and CMD parameters for better control over usage of image
ENTRYPOINT ["dnsmasq"]
CMD ["-p8053", "-k", "--log-facility=-"]
# Ideally healthcheck should be part of your application
HEALTHCHECK --interval=10s CMD ["dnsmasq", "--test"]
