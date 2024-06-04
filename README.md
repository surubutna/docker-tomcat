# docker-tomcat

Sample web app deployed in a Tomcat container on Docker

## Stack

    - CentOS 7
    - Apache Tomcat 8.5.100
    - Apache Tomcat Native Library 1.2.39
    - OpenSSL 3.3.0
    - OpenJDK 8

## Project structure
    docker-tomcat/
    ├── Dockerfile
    ├── README.md
    ├── sample.war
    ├── server.xml
    ├── ssl
    │   ├── localhost-rsa-cert.pem
    │   └── localhost-rsa-key.pem
    └── tomcat_run.sh

## Deployment
There's two ways to launch the application:

    1. Manually build and run
    2. Via script

    Note: Due to building OpenSSL 3.3.0 from source, first build may take a few minutes to complete.



## 1. Manually build and run
1.1 -
Build with default Dockerfile

```bash
  docker build -t tomcat-ssl3 .
```
1.2 - Run
```bash
  docker run -d -p 4041:4041 --name tomcat-ssl3-container tomcat-ssl3
```

## 2. Via script (tomcat_run.sh)
2.1 - Ensure script has execute permission
```bash
  chmod +x tomcat_run.sh
```
2.2 - Run script
```bash
  ./tomcat_run.sh
```

## Logs

After a sucessful run, check container logs 

```bash
  docker logs tomcat-ssl3-container
```

## Access app

Access app at: 

```bash
  https://localhost:4041/sample
```
