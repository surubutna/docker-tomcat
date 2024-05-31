#Base image
FROM centos:7

RUN yum -y update && \
    yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel wget gcc openssl-devel apr-util apr-devel make perl perl-IPC-Cmd perl-Data-Dumper && \
    yum -y clean all

#OpenSSL
RUN wget https://www.openssl.org/source/openssl-3.3.0.tar.gz -O /tmp/openssl.tar.gz && \
    tar xzf /tmp/openssl.tar.gz -C /tmp && \
    cd /tmp/openssl-3.3.0 && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib && \
    make && make install && \
    rm -rf /tmp/openssl-3.3.0 /tmp/openssl.tar.gz

#OpenSSL environment variables
ENV OPENSSL_HOME=/usr/local/openssl
ENV PATH=$OPENSSL_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$OPENSSL_HOME/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=$OPENSSL_HOME/lib/pkgconfig:$PKG_CONFIG_PATH

#Tomcat environment variables
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

#Tomcat 8.5.100
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.100/bin/apache-tomcat-8.5.100.tar.gz -O /tmp/tomcat.tar.gz && \
    mkdir -p $CATALINA_HOME && \
    tar xzf /tmp/tomcat.tar.gz --strip-components=1 -C $CATALINA_HOME && \
    rm /tmp/tomcat.tar.gz

#Tomcat Native 1.2.39
RUN wget https://dlcdn.apache.org/tomcat/tomcat-connectors/native/1.2.39/source/tomcat-native-1.2.39-src.tar.gz -O /tmp/tomcat-native.tar.gz && \
    tar xzf /tmp/tomcat-native.tar.gz -C /tmp && \
    cd /tmp/tomcat-native-1.2.39-src/native/ && \
    ./configure --with-apr=/usr/bin/apr-1-config --with-java-home=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.412.b08-1.el7_9.x86_64 --with-ssl=$OPENSSL_HOME --prefix=$CATALINA_HOME && \
    make && make install && \ 
    rm -rf /tmp/tomcat-native-1.2.39-src /tmp/tomcat-native.tar.gz

#Set the java.library.path to include the directory where libtcnative-1.so is located
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CATALINA_HOME/lib

#Sample app	
COPY sample.war $CATALINA_HOME/webapps/

#SSL certs + server config
COPY server.xml $CATALINA_HOME/conf/
COPY ssl/localhost-rsa-cert.pem $CATALINA_HOME/conf/
COPY ssl/localhost-rsa-key.pem $CATALINA_HOME/conf/

#Expose port
EXPOSE 4041

#Run Tomcat
CMD ["catalina.sh", "run"]

