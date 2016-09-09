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

# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
