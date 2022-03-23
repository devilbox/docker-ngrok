FROM debian:stretch-slim as builder

RUN set -eux \
	&& DEBIAN_FRONTEND=noninteractive apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		curl \
		dpkg-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux \
	&& URL="$( \
		curl -sS --fail https://ngrok.com/download \
		| grep -Eo "http(s)?://.+ngrok-stable-linux-$(dpkg-architecture --query DEB_BUILD_ARCH)\.tgz" \
		| head -1 \
	)" \
	&& curl -sS --fail -o /tmp/ngrok.tgz "${URL}" \
	&& tar xvfz /tmp/ngrok.tgz \
	&& rm /tmp/ngrok.tgz \
	&& mv ngrok /usr/local/bin \
	&& ngrok version | grep -E '^ngrok.+[.0-9]+$'


FROM debian:stretch-slim as final
RUN set -x \
	&& useradd -m -U -u 6737  -s /bin/bash ngrok \
	&& mkdir /home/ngrok/.ngrok2 \
	&& chown ngrok:ngrok /home/ngrok/.ngrok2

COPY --from=builder /usr/local/bin/ngrok /usr/local/bin/ngrok
COPY data/docker-entrypoint.sh /docker-entrypoint.sh
COPY data/ngrok.yml /home/ngrok/.ngrok2/ngrok.yml

RUN set -x \
	&& chown ngrok:ngrok /home/ngrok/.ngrok2/ngrok.yml

USER ngrok
ENV user=ngrok

CMD ["/docker-entrypoint.sh"]
