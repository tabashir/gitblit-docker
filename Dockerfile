FROM openjdk:7-jdk
MAINTAINER Jez McKinley <docker.jez@mckinley.biz>

# Install dependencies
RUN apt-get update && apt-get install -q -y git-core redis-server

# Install GitBlit
ENV GITBLIT_VERSION gitblit-1.8.0
ENV GITBLIT_TARBALL $GITBLIT_VERSION.tar.gz
ADD http://dl.bintray.com/gitblit/releases/$GITBLIT_TARBALL /opt
RUN tar xf /opt/$GITBLIT_TARBALL -C /opt && \
rm -f /opt/$GITBLIT_TARBALL && \
ln -s /opt/$GITBLIT_VERSION /opt/gitblit

# Setup properties
ADD gitblit.properties /opt/gitblit/data

# Volume mount
VOLUME /opt/gitblit/data

# BASE ports
EXPOSE 50101
EXPOSE 9418
EXPOSE 29418

# HTTPS port
#EXPOSE 50102

# Do the business
WORKDIR /opt/gitblit
CMD ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit/data"]
