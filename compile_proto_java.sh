
curl -LJO  https://services.gradle.org/distributions/gradle-6.4.1-bin.zip

unzip gradle-6.4.1-bin.zip

printf "apply plugin: 'maven'
apply plugin: 'java'
apply plugin: 'maven-publish'

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
}

" > build.gradle
./gradle-6.4.1/bin/gradle build



