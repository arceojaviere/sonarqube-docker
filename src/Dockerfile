FROM rhel7:latest

# Yum cleans and repolists are in place to be able to disable all repos and to allow the 
# "rhel-7-server-thirdparty-oracle-java-rpms" repo to be registered. Both actions will have no effect otherwise
# for reasons unkonwn
RUN yum clean all \
    && yum-config-manager --disable "*" 2>&1 > /dev/null\
    && yum repolist \
    && yum-config-manager --enable "rhel-7-server-rpms" --enable "rhel-7-server-thirdparty-oracle-java-rpms" \
    && yum -y install java-1.8.0-oracle-devel unzip\
    && yum clean all \
    && rm -rvf /var/cache/yum
WORKDIR /opt/sonarqube

# Reference and defaults for Sonar configurations
ENV SONAR_JDBC_URL=""\
    SONAR_JDBC_USERNAME=""\
    SONAR_JDBC_PASSWORD=""\
    SONAR_JDBC_MAXACTIVE="60"\
    SONAR_JDBC_MAXIDLE="15"\
    SONAR_JDBC_MINIDLE="5"\
    SONAR_JDBC_MAXWAIT="5000"\
    SONAR_JDBC_MINIIDLETIME="600000"\
    SONAR_JDBC_TIMEBETWEENEVICTIONS="30000"\
    SONAR_WEB_PORT="8080"\
    SONAR_WEB_MAXTHREADS="50"\
    SONAR_WEB_ACCEPTCOUNT="25"\
    SONAR_WEB_SESSIONTIMEOUT="4320"\
    SONAR_WEB_JAVAOPTS="-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError"
    

COPY ["run.sh","sonar.properties","./"]

# Installing Sonarqube. Preparing directory structure.
RUN curl -o sonarqube.zip -L https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.5.zip\
    && unzip sonarqube.zip\
    && rm sonarqube.zip\
    && mv sonar.properties sonarqube-6.5/conf/sonar.properties\
    && cp sonarqube-6.5/lib/bundled-plugins/* sonarqube-6.5/extensions/plugins/\
    && rm -rf sonarqube-6.5/bin/*\
    && rm -rf sonarqube-6.5/data\
    && mkdir /data\
    && ln -s /data sonarqube-6.5/data\
    && useradd -u 100001 sonarqube -d /opt/sonarqube -M\
    && chown -R sonarqube:sonarqube /opt/sonarqube /data\
    && chmod -R g+rwx /opt/sonarqube /data\
    && chmod a+x run.sh
USER sonarqube
EXPOSE 8080
ENTRYPOINT ./run.sh
