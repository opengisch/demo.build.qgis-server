FROM debian:12.5-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install -y \
    nginx-core

ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT [ "/tini", "--", "nginx" ]
CMD ["-g", "daemon off;"]
