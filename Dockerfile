FROM alpine

ENV DAEMON_RUN=true
ENV SPARK_VERSION=3.0.0
ENV HADOOP_VERSION=3.2.1
ENV SCALA_VERSION=2.13.1
ENV SCALA_HOME=/usr/share/scala
ENV PATH=$PATH:/spark/bin:/hadoop/bin:/usr/local/sbt/bin
ENV HADOOP_HOME=/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME

RUN apk update && apk upgrade && \
    mkdir -p /usr/local/sbt && mkdir "${SCALA_HOME}" && \
    apk add --no-cache openjdk11 bash curl jq libc6-compat python3 python3-dev py3-pip && ln /usr/bin/python3 /usr/bin/python && pip3 install --upgrade pip && pip3 install awscli boto3 && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar && \
    cd "/tmp" && \
    wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v1.3.8/sbt-1.3.8.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && sbt sbtVersion && \
    wget --no-verbose http://archive.apache.org/dist/spark/spark-3.0.0/spark-3.0.0-bin-hadoop3.2.tgz && tar -xvzf spark-3.0.0-bin-hadoop3.2.tgz && \
    mv spark-3.0.0-bin-hadoop3.2 /spark && \
    wget http://apache.mirrors.pair.com/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz && tar xzf hadoop-3.2.1.tar.gz && mv hadoop-3.2.1 /hadoop && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    apk del .build-dependencies && \        
    rm -rf "/tmp/"* && \
    cd /spark/jars && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.718/aws-java-sdk-s3-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.718/aws-java-sdk-bundle-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-dynamodb/1.11.718/aws-java-sdk-dynamodb-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-sqs/1.11.718/aws-java-sdk-sqs-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-sts/1.11.718/aws-java-sdk-sts-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-iam/1.11.718/aws-java-sdk-iam-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.718/aws-java-sdk-1.11.718.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar && \
    wget https://repo1.maven.org/maven2/org/xerial/snappy/snappy-java/1.1.7.3/snappy-java-1.1.7.3.jar
    

