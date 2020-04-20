FROM swift:5.2
MAINTAINER Enki
# Vapor setup
RUN cd /home \
    && git clone https://github.com/vapor/toolbox.git \
    && cd toolbox \
    && swift build -c release --disable-sandbox --enable-test-discovery \
    && mv .build/release/vapor /usr/local/bin
RUN vapor --help