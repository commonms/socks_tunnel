# Isban Tunneling
FROM ubuntu:16.10
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

ENV http_proxy http://$CORPORATE_PROXY_HOST:$CORPORATE_PROXY_PORT
ENV HTTP_PROXY $http_proxy
ENV https_proxy $http_proxy
ENV HTTPS_PROXY $http_proxy
ENV NO_PROXY 127.0.0.1

RUN echo "Acquire::http::Proxy \"$HTTP_PROXY\";" > /etc/apt/apt.conf

# Target proxy parameters
ENV TARGET_PROXY_HOST 5.196.14.85
ENV TARGET_PROXY_PORT 18080
ENV TARGET_PROXY_USER commonms
ENV TARGET_PROXY_PASS common$

# Entrypoint starts SSHD
COPY entrypoint.sh /bin/
RUN chmod 755 /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]

# Add normal user
RUN useradd -m $TARGET_PROXY_USER \
    && echo "$TARGET_PROXY_PASS\n$TARGET_PROXY_PASS\n" | passwd $TARGET_PROXY_USER

USER $TARGET_PROXY_USER
