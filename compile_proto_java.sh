
curl -LJO  https://services.gradle.org/distributions/gradle-6.4.1-bin.zip

unzip gradle-6.4.1-bin.zip

printf "apply plugin: 'maven'
apply plugin: 'java'

group 'com.oyster.protos'
version '1.0'


sourceCompatibility = 1.8
targetCompatibility = 1.8

def protobufVersion = '1.19.0'

repositories {
    mavenCentral()
    mavenLocal()
}

dependencies {
    compile group: 'com.oyster.entities', name: 'entities', version: '1.0-SNAPSHOT'
    compile group: 'io.grpc', name: 'grpc-protobuf', version: protobufVersion
    compile group: 'io.grpc', name: 'grpc-netty-shaded', version: protobufVersion
    compile group: 'io.grpc', name: 'grpc-stub', version: protobufVersion
}
" > build.gradle
./gradle-6.4.1/bin/gradle build



