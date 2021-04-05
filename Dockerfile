FROM debian

ENV VERSION=1.6

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    libasound2-dev \
    libudev-dev \
    build-essential \
    cmake \
    ca-certificates \
    tini \
    alsa-utils \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && git clone -bare --depth 1 https://github.com/wb2osz/direwolf.git --branch $VERSION \
    && cd direwolf \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && make install-conf

RUN find /usr/local/bin -type f -exec strip -p --strip-debug {} \; \
    && addgroup --gid 10001 direwolf \
    && adduser --system --uid 10001 --gid 10001 direwolf \
    && usermod -a -G audio direwolf

EXPOSE 8000/tcp
EXPOSE 8001/tcp

VOLUME /direwolf

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/direwolf"]

USER direwolf

CMD ["-c","/direwolf/direwolf.conf","-a","900","-t","0","-X","1"]
