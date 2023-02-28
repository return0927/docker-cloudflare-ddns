FROM alpine:3

WORKDIR /rundir

RUN cd /rundir && \
    apk --no-cache add curl

ADD update-ip.sh /rundir/

ARG TOKEN
ARG DOMAIN
ARG ZONE_ID

ENV TOKEN="${TOKEN}"
ENV DOMAIN="${DOMAIN}"
ENV ZONE_ID="${ZONE_ID}" 

ENTRYPOINT "/rundir/update-ip.sh"

