#!/bin/bash

if [ -d "gradle-6.4.1/" ]; then
        echo 'using existing gradle'
else
        curl -LJO  https://services.gradle.org/distributions/gradle-6.4.1-bin.zip

        unzip gradle-6.4.1-bin.zip
fi;

artifact_version="0.0.1"
if [ ! -z "$1" ]; then
        artifact_version="$1"
fi;

echo "build version: $artifact_version"

printf "apply plugin: 'maven'
apply plugin: 'java'
apply plugin: 'maven-publish'

group 'com.oyster.protos'

version '${artifact_version}'


sourceCompatibility = 1.8
targetCompatibility = 1.8

def protobufVersion = '1.19.0'

repositories {
    mavenCentral()
    mavenLocal()
}

dependencies {
    compile group: 'javax.annotation', name: 'javax.annotation-api', version: '1.3.2'
    compile group: 'io.grpc', name: 'grpc-protobuf', version: protobufVersion
    compile group: 'io.grpc', name: 'grpc-netty-shaded', version: protobufVersion
    compile group: 'io.grpc', name: 'grpc-stub', version: protobufVersion
}

publishing {

  repositories {
    maven {
      name = 'GitHubPackages'
      url = 'https://maven.pkg.github.com/ismaelmk/proto_repo'
      credentials(PasswordCredentials){
        username = System.getenv('GITHUB_ACTOR')
        password = System.getenv('GITHUB_TOKEN')
      }
    }
  }
  publications {
     gpr(MavenPublication) {
         from(components.java)
    }
  }
}

" > build.gradle
./gradle-6.4.1/bin/gradle build
./gradle-6.4.1/bin/gradle install

ls -l build/
ls -l build/libs



