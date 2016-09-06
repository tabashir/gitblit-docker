# Basics
#
FROM openjdk:7-jdk
MAINTAINER Jez McKinley <docker.jez@mckinley.biz>
RUN apt-get update && apt-get install -q -y git-core redis-server

# Install Gitblit

ENV GITBLIT_VERSION gitblit-1.8.0
ENV GITBLIT_TARBALL $GITBLIT_VERSION.tar.gz

ADD http://dl.bintray.com/gitblit/releases/$GITBLIT_TARBALL /opt

RUN tar xvf /opt/$GITBLIT_TARBALL -C /opt && \
rm -f /opt/$GITBLIT_TARBALL && \
ln -s /opt/$GITBLIT_VERSION /opt/gitblit && \
ln -s  /opt/gitblit/data/git /opt/repos

ADD gitblit.properties /opt/gitblit/data

# Setup the Docker container environment and run Gitblit
WORKDIR /opt/gitblit
VOLUME /opt/repos

# BASE ports
EXPOSE 50101
EXPOSE 9418
EXPOSE 29418

# HTTPS port
#EXPOSE 50102


cmd ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit/data"]
