FROM ubuntu:24.04

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HBASE_VERSION=2.5.8
ENV HBASE_HOME=/opt/hbase
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV PATH=$PATH:$HBASE_HOME/bin

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk-headless \
    wget \
    curl \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Download and install HBase
RUN wget https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz && \
    tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz && \
    mv hbase-${HBASE_VERSION} "$HBASE_HOME" && \
    rm hbase-${HBASE_VERSION}-bin.tar.gz

# Create necessary directories
RUN mkdir -p /opt/hbase/logs && \
    mkdir -p /tmp/zookeeper

# Copy configuration files
COPY config/* $HBASE_CONF_DIR/

# Set permissions
RUN chmod +x "$HBASE_HOME"/bin/*

# Expose HBase ports
EXPOSE 16010 16020 16030 2181

WORKDIR $HBASE_HOME

# Default command
CMD ["bash"]