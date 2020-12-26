FROM debian:stable-slim as builder

RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-venv

ARG GLANCES=/usr/local/apps/glances
ARG GLANCES_VERSION
RUN python3.7 -m venv ${GLANCES}
RUN ${GLANCES}/bin/pip install -U pip wheel

RUN ${GLANCES}/bin/pip install glances==$GLANCES_VERSION

FROM debian:stable-slim as releaser

ARG GLANCES=/usr/local/apps/glances

LABEL \
    org.opencontainers.image.authors="rocky.burt@gmail.com" \
    org.opencontainers.image.url="https://github.com/rockyburt/docker-glances" \
    org.opencontainers.image.source="https://github.com/rockyburt/docker-glances" \
    org.opencontainers.image.title="Glances" \
    org.opencontainers.image.description="Docker deployment for Glances <https://nicolargo.github.io/glances/>"

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y apt-utils && \
    apt-get install -y python3 && \
    ln -s ${GLANCES}/bin/glances /usr/local/bin && \
    rm -Rf /var/lib/apt/lists/*

COPY --from=builder ${GLANCES} ${GLANCES}

CMD ["/usr/local/bin/glances"]
