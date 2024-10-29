ARG DEBIAN_VERSION
FROM debian:${DEBIAN_VERSION} AS sipp-base

ARG BUILD_FLAGS

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    binutils \
    cmake \
    g++ \
    gcc \
    git \
    libncurses-dev \
    make \
    ca-certificates \
    $(echo "$BUILD_FLAGS" | grep -q "SSL" && echo "libssl-dev") \
    $(echo "$BUILD_FLAGS" | grep -q "PCAP" && echo "libpcap-dev") \
    $(echo "$BUILD_FLAGS" | grep -q "GSL" && echo "libgsl-dev") \
    $(echo "$BUILD_FLAGS" | grep -q "SCTP" && echo "libsctp-dev") && \
    apt-get clean

FROM sipp-base AS sipp-builder

ARG SIPP_VERSION
ARG BUILD_FLAGS

WORKDIR /usr/local/src

## Fetch SIPp repo
RUN git clone https://github.com/SIPp/sipp.git --branch=${SIPP_VERSION} sipp

RUN cd sipp && \
    cmake . \
    $(echo "$BUILD_FLAGS" | grep -q "SSL" && echo "-DUSE_SSL=1") \
    $(echo "$BUILD_FLAGS" | grep -q "PCAP" && echo "-DUSE_PCAP=1") \
    $(echo "$BUILD_FLAGS" | grep -q "GSL" && echo "-DUSE_GSL=1") \
    $(echo "$BUILD_FLAGS" | grep -q "SCTP" && echo "-DUSE_SCTP=1") && \
    make

RUN cp -rp sipp/sipp /usr/bin/

FROM sipp-builder AS sipp

WORKDIR /usr/local/src

COPY entrypoint.sh ./

CMD ["sipp", "-v"]
ENTRYPOINT [ "./entrypoint.sh" ]
