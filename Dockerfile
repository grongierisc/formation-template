ARG IMAGE=intersystemsdc/irishealth-community:2020.4.0.521.0-zpm
ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2020.1.408.0
ARG IMAGE=intersystemsdc/irishealth-community:2020.4.0.547.0-zpm
FROM $IMAGE
# copy files
COPY . /tmp/iris

USER root

# Update package and install sudo
RUN apt-get update && apt-get install -y \
	openjdk-8-jdk \
	nano \
	sudo && \
	/bin/echo -e ${ISC_PACKAGE_MGRUSER}\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers && \
	sudo -u ${ISC_PACKAGE_MGRUSER} sudo echo enabled passwordless sudo-ing for ${ISC_PACKAGE_MGRUSER}

RUN export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN export PATH=$PATH:$JAVA_HOME/bin

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

# load demo stuff
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris/iris.script && iris stop IRIS quietly
