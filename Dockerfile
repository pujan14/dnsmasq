# Using multistage docker file to separate build and runtime containers separate
# For security and reliability use sha256 checksums for pinning, tags are mutable
# Add comment for docker tag for future reference gcc:10
FROM gcc@sha256:20543986b0b9dde239d7b1b70a79598bb489a32739eec046956ab95ba7e26739 as build
# Install specific version
ARG VERSION="2.82"
# Get signing key
RUN gpg --keyserver keyring.debian.org --recv 15CDDA6AE19135A2
# Download specific release and it's signing file
RUN wget http://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz
RUN wget http://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz.asc
# Verify downloaded file with signing key and extract only if verification passes
RUN gpg --verify dnsmasq-$VERSION.tar.gz.asc dnsmasq-$VERSION.tar.gz && tar -xzf dnsmasq-$VERSION.tar.gz
# Use WORKDIR instead of cd inside dockerfile for clarity and reliability
WORKDIR /dnsmasq-$VERSION
# Compile binary to copy in next image
RUN make install

# For security and reliability use sha256 checksums for pinning, tags are mutable
# Add comment for docker tag for future reference gcr.io/distroless/base-debian10:nonroot
FROM gcr.io/distroless/base-debian10@sha256:00745f221ff47557e777d9044929f766312fd5fe5affe27b73c0ad9cde2b3f6e
# Do not use maintainer command, it's deprecated
LABEL maintainer="Pujan Shah"
# Copy only binary and any other required files
COPY --from=build /usr/local/sbin/dnsmasq /usr/local/sbin/dnsmasq
# Switch to nonroot or nobody user whenever possible in runtime images
USER nonroot
# Expose volumes for passing config
VOLUME /etc/dnsmasq.d/
# nonroot user can only use ports higher than 1024
EXPOSE 8053 8053/udp
# Specify both ENTRYPOINT and CMD parameters for better control over usage of image
ENTRYPOINT ["dnsmasq"]
CMD ["-p8053", "-k", "--log-facility=-"]
# Ideally healthcheck should be part of your application
HEALTHCHECK --interval=10s CMD ["dnsmasq", "--test"]
