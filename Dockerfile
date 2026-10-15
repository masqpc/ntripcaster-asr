FROM ubuntu:18.04 as builder

COPY ntripcaster /ntripcaster

WORKDIR /ntripcaster

RUN apt-get update && apt-get install build-essential --assume-yes

RUN ./configure

# Create the runtime config files from the shipped examples if they were not committed.
RUN cd conf \
    && ([ -f ntripcaster.conf ] || cp ntripcaster.conf.dist ntripcaster.conf) \
    && ([ -f sourcetable.dat ] || cp sourcetable.dat.dist sourcetable.dat)

RUN make install

# The builder image is dumped and a fresh image is used
# just with the built binary, config and logs made from 'make install'
FROM ubuntu:18.04
COPY --from=builder /usr/local/ntripcaster/ /usr/local/ntripcaster/

EXPOSE 2101
WORKDIR /usr/local/ntripcaster/logs
CMD /usr/local/ntripcaster/bin/ntripcaster
