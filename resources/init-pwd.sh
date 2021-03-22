#! /bin/bash

apk add openjdk11 maven
export JAVA_HOME=/usr/lib/jvm/default-jvm

java --version
mvn --version

# Descargar el paquete
wget https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/2.4.3/spring-boot-cli-2.4.3-bin.tar.gz

# Descomprimimos el tar. Crea la carpeta spring-2.4.3
tar -zxf spring-boot-cli-2.4.3-bin.tar.gz
rm -rf spring-boot-cli-2.4.3-bin.tar.gz
mv spring-2.4.3 /opt

export PATH=/opt/spring-2.4.3/bin:$PATH

# Ejemplo de uso:
# Creamos una aplicación Spring Boot con la dependencia web
spring init --dependencies=web my-project

# Generamos el jar
mvn -f my-project/pom.xml package

export RMI_PORT=49152
export JMX_OPTIONS="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=$RMI_PORT -Dcom.sun.management.jmxremote.rmi.port=$RMI_PORT -Djava.rmi.server.hostname=localhost -Dcom.sun.management.jmxremote.local.only=false"

java $JMX_OPTIONS -jar my-project/target/my-project-0.0.1-SNAPSHOT.jar 1> /dev/null &

# Reiniciar sshd para que nos permita hacer port forwarding y poder monitorizar el proceso java
kill -9 $(pidof sshd)
/usr/sbin/sshd -o AllowTcpForwarding=yes -o PermitRootLogin=yes

echo "##################################################################################################################"
echo "# Welcome to Openathon VIII! :)                                                                                  #"
echo "# Ejecuta en tu equipo local: ssh -L 49152:localhost:49152 <HOSTNAME_PWD>@direct.labs.play-with-docker.com       #"
echo "# Ejecuta en tu equipo local: \$JAVA_HOME/bin/jconsole he indica localhost:49152                                 #"
echo "# Verás el proceso que acaba de lanzar el script                                                                 #"
echo "# Ejecuta en PWD 'pkill java' para matar el proceso que hemos lanzado                                            #"
echo "# The Openathon Team                                                                                             #"
echo "##################################################################################################################"
