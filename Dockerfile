FROM alpine:3.4

ENV BROWSER="chrome"
ENV NODE_BROWSER_VERSION="chrome"
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
  openjdk7-jre\
  openssh-client\
  paxctl \
  python3\
  python3-dev\
  tar \
  unzip\
  wget

# Pull latest Selenium Standalone JAR
RUN curl -L https://goo.gl/hvDPsK --output /usr/bin/selenium.jar

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

ENV JAVA_VERSION=9.0.4
ENV JAVA_HOME=/opt/java/current
ENV PATH=$PATH:$JAVA_HOME/bin

RUN wget --no-cookies \
  --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  "http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz"



# https://wiki.alpinelinux.org/wiki/Installing_Oracle_Java ????
RUN mkdir -p /opt/java \
  && mv jdk-9.0.4_linux-x64_bin.tar.gz  /opt/java/jdk-9.0.4_linux-x64_bin.tar.gz \
  && cd /opt/java
  && tar zxvf jdk-9.0.4_linux-x64_bin.tar.gz

RUN ln -s /opt/java/jdk-9.0.4/bin /opt/java/current \
  && rm jdk-9.0.4_linux-x64_bin.tar.gz \
  && touch /etc/profile.d/java.sh \
  && echo -e 'export JAVA_HOME=/opt/java/current\nexport PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile.d/java.sh \
  && sh /etc/profile.d/java.sh \
  && paxctl -c /opt/java/jdk-9.0.4/bin/java \
  && paxctl -m /opt/java/jdk-9.0.4/bin/java \
  && paxctl -c /opt/java/jdk-9.0.4/bin/javac \
  && paxctl -m /opt/java/jdk-9.0.4/bin/javac \
  && setfattr -n user.pax.flags -v "mr" /opt/java/jdk-9.0.4/bin/java \
  && setfattr -n user.pax.flags -v "mr" /opt/java/jdk-9.0.4/bin/javac \
  && cd / \
  && java -version

# Galen install other than NPM?
#RUN wget https://github.com/galenframework/galen/releases/download/galen-$GALEN_VERSION/galen-bin-$GALEN_VERSION.zip \
#  && unzip galen-bin-$GALEN_VERSION \
#  && cd galen-bin-$GALEN_VERSION \
#  && . install.sh \
#  && cd ..


# RUN galen serve
