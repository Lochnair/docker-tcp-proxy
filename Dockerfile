FROM haproxy:2.2-alpine

RUN apk add --no-cache python3 &&\
    pip3 install --no-cache-dir dnspython

COPY magic-entrypoint.py /magic-entrypoint

# Create user HOME
RUN mkdir -p /app/home

# Create a user group 'tcpproxy'
RUN addgroup -S tcpproxy

# Create a user 'tcpproxy' under 'tcpproxy'
RUN adduser -S -D --home /app/home --ingroup tcpproxy tcpproxy

# Chown all the files to the app user.
RUN chown -R tcpproxy:tcpproxy /app/home

# Switch to 'tcpproxy'
USER tcpproxy

ENTRYPOINT ["/magic-entrypoint", "/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]

ENV NAMESERVERS="208.67.222.222 8.8.8.8 208.67.220.220 8.8.4.4" \
    LISTEN=:100 \
    PRE_RESOLVE=0 \
    TALK=talk:100 \
    TIMEOUT_CLIENT=5s \
    TIMEOUT_CLIENT_FIN=5s \
    TIMEOUT_CONNECT=5s \
    TIMEOUT_SERVER=5s \
    TIMEOUT_SERVER_FIN=5s \
    TIMEOUT_TUNNEL=5s \
    UDP=0 \
    VERBOSE=0
