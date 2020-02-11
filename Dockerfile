FROM node:alpine

RUN apk add --no-cache -t .build-deps gcc git make build-base \
    && cd /tmp \
    && git clone https://github.com/brandt/symlinks \
    && cd symlinks \
    && gcc -Wall -Wstrict-prototypes -O2  -o /usr/local/bin/symlinks symlinks.c \
    && rm -rf /tmp/symlinks \
    && apk del .build-deps
RUN apk add --no-cache git bash rdfind php php-iconv php-json php-openssl php-phar php-xmlreader php-mbstring php-pdo \
    && cd /tmp \
    && git clone https://github.com/magento/baler \
    && cd baler \
    && npm install -g terser \
    && npm install \
    && npm run build \
    && npm link

ADD entrypoint.sh /entrypoint.sh

CMD /entrypoint.sh
