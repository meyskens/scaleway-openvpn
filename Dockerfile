## -*- docker-image-name: "scaleway/openvpn:latest" -*-
FROM scaleway/debian:amd64-jessie
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/debian:armhf-jessie       # arch=armv7l
#FROM scaleway/debian:arm64-jessie       # arch=arm64
#FROM scaleway/debian:i386-jessie        # arch=i386
#FROM scaleway/debian:mips-jessie        # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter


# Install packages
RUN apt-get -q update        \
 && apt-get -y -q upgrade    \
 && apt-get install -y -q    \
 	easy-rsa			\
	curl                 \
	iptables             \
	iptables-persistent  \
	openvpn              \
	stunnel4             \
	uuid                 \
 && apt-get clean

# Patch rootfs
COPY ./overlay/ /

# Install Caddy
RUN curl https://getcaddy.com | bash && \
	groupadd -g 33 www-data || true && \
	useradd \
  		-g www-data --no-user-group \
  		--home-dir /var/www --no-create-home \
 		--shell /usr/sbin/nologin \
  		--system --uid 33 www-data  || true  && \
	chown -R root:www-data /etc/caddy  && \
	mkdir /etc/ssl/caddy  && \
	chown -R www-data:root /etc/ssl/caddy  && \
	chmod 0770 /etc/ssl/caddy  && \
	systemctl enable caddy

# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
