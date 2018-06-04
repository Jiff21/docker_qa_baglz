FROM alpine:3.4

MAINTAINER Jiff Campbell
ADD VERSION .

ENV PYTHONPATH="$PYTHONPATH:/usr/lib/python3.5"


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
ENV GECKODRIVER_VERSION=0.19.1
ENV GALEN_VERSION=2.3.6

# Extend alpine with basic tools
RUN apk --update --no-cache add\
  alpine-sdk\
  autoconf \
  automake \
  bash\
  build-base\
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

# Install geckodriver
RUN wget -qO- https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz | tar xvz \
  && mv geckodriver /usr/bin/geckodriver


# Pull latest chromedriver and put in path.
RUN LATEST_CHROMEDRIVER=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE) \
  && wget https://chromedriver.storage.googleapis.com/$LATEST_CHROMEDRIVER/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && mv chromedriver /usr/bin/chromedriver \
  && rm chromedriver_linux64.zip

# Update pip and install all test dependencies.
RUN pip3 install --upgrade pip setuptools
RUN pip3 install allure-behave==2.3.2b1 \
  git+https://github.com/behave/behave \
  chai==1.1.2 \
  google-auth==1.4.1 \
  google-api-python-client==1.6.5 \
  locustio==0.8.1 \
  pyHamcrest==1.9.0 \
  python-owasp-zap-v2.4==0.0.11 \
  pyzmq==16.0.2 selenium==3.8.1 \
  requests==2.18.1 \
  requests-toolbelt==0.8.0 \
  zapcli==0.8.0


# Galen install other than NPM?
RUN wget https://github.com/galenframework/galen/releases/download/galen-$GALEN_VERSION/galen-bin-$GALEN_VERSION.zip \
  && unzip galen-bin-$GALEN_VERSION \
  && cd galen-bin-$GALEN_VERSION \
  && chmod +x install.sh \
  && . install.sh \
  && cd ..

COPY chrome_extensions/ usr/bin/chrome_extensions/

CMD ["/bin/sh"]
