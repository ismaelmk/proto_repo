#!/bin/bash

os_type="$(uname)"
os_arch=$(uname -m)
protoc_version="3.6.1"
protoc_grpc_version="1.19.0"

if [[ "$os_type" == "cygwin" ]]; then
       echo "POSIX compatibility layer and Linux environment emulation for Windows"
       echo "build protoc manually"
       exit 0
elif [[ "$os_type" == "msys" ]]; then
       echo "Lightweight shell and GNU utilities compiled for Windows (part of MinGW)"
       echo "build protoc manually"
       exit 0
elif [[ "$os_type" == "freebsd"* ]]; then
       echo "freebsd not supported"
       echo "build protoc manually"
       exit 0
elif ! [[ "$os_type" = "Linux" ]] && ! [[ "$os_type" = "Darwin" ]]; then 
       echo "unknown OS not supported: ${os_type}"
       echo "build protoc manually"
       exit 0
fi


if [ -f "protoc" ]; then 
   protoc_v="$(./protoc --version | awk '{print $2}')"
fi

if ! [ "$protoc_v" == "$protoc_version" ]; then

   protoc_url_file=""
   protoc_url_base="https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/"

   if [[ "$os_type" == "Linux" ]]; then
      case $os_arch in
         (amd64|x86_64)   protoc_url_file="protoc-${protoc_version}-linux-x86_64.zip" ;;
         (i386|i586|i686) protoc_url_file="protoc-${protoc_version}-linux-x86_32.zip" ;;
         (*) echo "os arch not supported $os_arch" && exit 0 ;;
      esac
   elif [[ "$os_type" == "Darwin"* ]]; then
      case $os_arch in
         (amd64|x86_64)   protoc_url_file="protoc-${protoc_version}-osx-x86_64.zip" ;;
         (i386|i586|i686) protoc_url_file="protoc-${protoc_version}-osx-x86_32.zip" ;;
         (*) echo "os arch not supported $os_arch" && exit 0 ;;
      esac
   fi

   curl -LJO "${protoc_url_base}${protoc_url_file}"
   unzip -j "${protoc_url_file}" "bin/protoc"
   rm "${protoc_url_file}"
fi


if [[ "$os_type" == "Linux" ]]; then
   case $os_arch in
     (amd64|x86_64)   protoc_grpc_url_file="protoc-gen-grpc-java-${protoc_grpc_version}-linux-x86_64.exe" ;;
     (i386|i586|i686) protoc_grpc_url_file="protoc-gen-grpc-java-${protoc_grpc_version}-linux-x86_32.exe" ;;
     (*) echo "os arch not supported $os_arch" && exit 0 ;;
   esac
elif [[ "$os_type" == "Darwin"* ]]; then
   case $os_arch in
     (amd64|x86_64)   protoc_grpc_url_file="protoc-gen-grpc-java-${protoc_grpc_version}-osx-x86_64.exe" ;;
     (*) echo "os arch not supported $os_arch" && exit 0 ;;
   esac
fi


if ! [ -f "$protoc_grpc_url_file" ]; then
      curl -LJO "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${protoc_grpc_version}/${protoc_grpc_url_file}"
      chmod +x "${protoc_grpc_url_file}"
fi

if [ -d "com/" ]; then 
   echo "deleting existing com folder"
   rm -rf "com"
fi

if [ -d "grpc" ]; then
    echo "deleting existing grpc folder"
    rm -rf "grpc"
fi

echo "generating java files from proto contracts"
./protoc --java_out=. *.proto

./protoc --plugin=protoc-gen-grpc-java="${protoc_grpc_url_file}" --grpc-java_out=./src/main/java --proto_path=./ *.proto

ls -l 

ls -l src/main/java 
