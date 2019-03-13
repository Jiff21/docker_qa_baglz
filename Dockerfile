FROM alpine:3.8

MAINTAINER Jiff Campbell
ADD VERSION .

ENV PYTHONPATH="$PYTHONPATH:/usr/lib/python3.5"

ENV PYTHONPATH="$PYTHONPATH:/usr/lib/python3.6/site-packages/"

# Selenium Hub Settings
ENV GRID_MAX_SESSION=""
ENV GRID_TIMEOUT="60"
ENV GRID_BROWSER_TIMEOUT="60"
ENV SHM_SIZE="512MB"
ENV GRID_NEW_SESSION_WAIT_TIMEOUT="60"
# Node settings
ENV HUB_PORT_4444_TCP_ADDR="hub"
ENV NODE_MAX_INSTANCES=5
ENV NODE_MAX_SESSION=5
ENV HUB_PORT_4444_TCP_PORT=4.4.4.4
ENV BROWSER="chrome"
ENV FIREFOX_VERSION="58.0.1"
ENV SE_OPTS=""
# Local install Versions
ENV GECKODRIVER_VERSION=0.23.0
ENV GALEN_VERSION=2.3.6

# Extend alpine with basic tools
RUN apk --update --no-cache add\
  alpine-sdk\
  autoconf \
  automake \
  bash\
  build-base\
  chromium\
  chromium-chromedriver\
  curl\
  git\
  gzip \
  jpeg\
  jpeg-dev\
  libffi\
  libffi-dev\
  libpng \
  libpng-dev\
  libtool \
  mysql\
  mysql-client\
  mysql-dev\
  nasm\
  nodejs\
  openjdk8-jre\
  openssh-client\
  paxctl \
  python3\
  python3-dev\
  tar \
  unzip\
  wget


# Pull latest Selenium Standalone JAR
RUN curl -L https://goo.gl/hvDPsK --output /usr/bin/selenium.jar
COPY /files/nodeconfig.json /usr/nodeconfig.json

# Install latest Geckodriver & Chromedriver
COPY geckodriver.sh /geckodriver.sh
RUN ./geckodriver.sh
# Using chromium-chromedriver package for now.

# Get binary for running browsermob.
COPY browsermob_install.sh /browsermob_install.sh
RUN ./browsermob_install.sh && rm browsermob_install.sh

# Update pip and install all test dependencies.
RUN pip3 install --upgrade pip setuptools
RUN pip3 install allure-behave==2.5.0 \
  bandit==1.5.1 \
  behave==1.2.6 \
  browsermob-proxy==0.8.0 \
  chai==1.1.2 \
  google-auth==1.5.1 \
  google-api-python-client==1.7.7 \
  locustio==0.8.1 \
  pillow==5.4.1 \
  pyHamcrest==1.9.0 \
  pylint==2.2.2 \
  python-dotenv==0.9.1 \
  python-owasp-zap-v2.4==0.0.12 \
  pyzmq==16.0.2 \
  selenium==3.14.1 \
  requests==2.20.1 \
  requests-toolbelt==0.8.0

# Galen install
RUN wget https://github.com/galenframework/galen/releases/download/galen-$GALEN_VERSION/galen-bin-$GALEN_VERSION.zip \
  && unzip galen-bin-$GALEN_VERSION \
  && cd galen-bin-$GALEN_VERSION \
  && chmod +x install.sh \
  && . install.sh \
  && cd .. \
  && rm galen-bin-$GALEN_VERSION.zip

COPY chrome_extensions/ usr/bin/chrome_extensions/

CMD ["/bin/sh"]
