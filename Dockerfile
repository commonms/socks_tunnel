# Isban Tunneling
FROM ubuntu
MAINTAINER Jose M. Fernandez-Alba <jm.fernandezalba@commonms.com>

# SSH port
EXPOSE 22

# Install dependencies
RUN apt-get update && apt-get install -y \
	openssh-server \
    sshpass \
	netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*

# Isban proxy
ENV CORPORATE_PROXY_HOST 172.31.219.30
ENV CORPORATE_PROXY_PORT 8080

ENV HTTP_PROXY http://$CORPORATE_PROXY_HOST:$CORPORATE_PROXY_PORT
ENV HTTPS_PROXY $HTTP_PROXY
ENV NO_PROXY 127.0.0.1

# Target proxy parameters
ENV TARGET_PROXY_HOST 5.196.14.85
ENV TARGET_PROXY_PORT 18080
ENV TARGET_PROXY_USER commonms
ENV TARGET_PROXY_PASS common$

RUN useradd -m $TARGET_PROXY_USER \
    && echo "$TARGET_PROXY_PASS\n$TARGET_PROXY_PASS\n" | passwd $TARGET_PROXY_USER

# Entrypoint starts SSHD
COPY entrypoint.sh /sbin/
RUN chmod 755 /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
