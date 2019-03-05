FROM debian:stretch-slim
MAINTAINER "cytopia" <cytopia@everythingcli.org>

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		curl \
		ca-certificates \
		unzip \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& URL="$( curl -sS  https://ngrok.com/download | grep -Eo "href=\".+ngrok-stable-linux-amd64\.zip\"" | awk -F'\"' '{print $2}' )" \
	&& curl -sS -o /tmp/ngrok.zip ${URL} \
	&& unzip /tmp/ngrok.zip \
	&& rm /tmp/ngrok.zip \
	&& mv ngrok /usr/local/bin \
	&& ngrok version | grep -E '^ngrok.+[.0-9]+$' \
	\
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
		curl \
		ca-certificates \
		unzip \
	&& rm -rf /var/lib/apt/lists/*

RUN set -x \
	&& useradd -m -U -u 6737  -s /bin/bash ngrok \
	&& mkdir /home/ngrok/.ngrok2 \
	&& chown ngrok:ngrok /home/ngrok/.ngrok2

COPY data/docker-entrypoint.sh /docker-entrypoint.sh
COPY data/ngrok.yml /home/ngrok/.ngrok2/ngrok.yml

RUN set -x \
	&& chown ngrok:ngrok /home/ngrok/.ngrok2/ngrok.yml

USER ngrok
ENV user=ngrok

CMD ["/docker-entrypoint.sh"]
