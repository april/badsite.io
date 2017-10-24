# Start with Ubuntu 16.04 (LTS), and build badsite.io up from there
FROM ubuntu:16.04
MAINTAINER April King <april@twoevils.org>
EXPOSE 80 443
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    make \
    nginx \
    ruby \
    ruby-dev
RUN gem install jekyll

# Install badsite.io
ADD . badsite.io
WORKDIR badsite.io
RUN make inside-docker

# Start things up!
CMD nginx && tail -f /var/log/nginx/access.log /var/log/nginx/error.log
