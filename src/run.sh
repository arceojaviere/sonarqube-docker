#!/bin/bash
umask 0002
set -e
echo "Configuring sonar.properties..."
if [ "x$SONAR_JDBC_URL" == "x" ]; then
    echo "Using H2 embedded DB."
    sed -ri 's/^(sonar\.jdbc.*)$/#\1/g' sonarqube-6.5/conf/sonar.properties
fi

echo "Running main process"
exec java -jar sonarqube-6.5/lib/sonar-application-6.5.jar \
  -Dsonar.log.console=true
