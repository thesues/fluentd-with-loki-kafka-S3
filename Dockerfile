FROM alpine:3.8
LABEL maintainer "Fluentd developers <fluentd@googlegroups.com>"
LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.3.3"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete' has no effect
RUN apk update \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb ruby-etc ruby-webrick \
        tini \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev gnupg \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 3.3.10 \
 && gem install json -v 2.1.0 \
 && gem install fluentd -v 1.3.3 \
 && gem install bigdecimal -v 1.3.5 \
 && gem install fluent-plugin-kafka fluent-plugin-record-modifier fluent-plugin-s3 fluent-plugin-loki \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY out_loki.rb /usr/lib/ruby/gems/2.5.0/gems/fluent-plugin-loki-0.2.0/lib/fluent/plugin
ENTRYPOINT ["fluentd"]
