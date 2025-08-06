FROM ubuntu:24.04

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk-headless \
    wget \
    curl \
    ssh \
    rsync \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH for Hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Download and install Hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} "$HADOOP_HOME" && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

# Create necessary directories
RUN mkdir -p /tmp/hadoop-logs && \
    mkdir -p /opt/hadoop/logs && \
    mkdir -p /data/hadoop/hdfs/namenode && \
    mkdir -p /data/hadoop/hdfs/datanode

# Copy configuration files
COPY config/* $HADOOP_CONF_DIR/

# Set permissions
RUN chmod +x "$HADOOP_HOME"/sbin/*

# Expose Hadoop ports
EXPOSE 9870 9000 8088 8042 19888

WORKDIR $HADOOP_HOME

# Default command
CMD ["bash"]
