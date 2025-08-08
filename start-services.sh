#!/bin/bash

# Start SSH service
service ssh start
if [ -z "$HOST_IP" ]; then
    HOST_IP=localhost
fi

sed -i "s|\${HOST_IP}|$HOST_IP|" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
sed -i "s|\${HOST_IP}|$HOST_IP|" $HADOOP_HOME/etc/hadoop/core-site.xml
sed -i "s|\${HOST_IP}|$HOST_IP|" $HBASE_HOME/conf/hbase-site.xml
echo "Using HOST_IP: $HOST_IP"

# sed -i "s|<name>dfs.datanode.hostname</name>.*|<name>dfs.datanode.hostname</name><value>$HOST_IP</value>|" $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Pre-accept SSH host keys to avoid prompts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H ${HOSTNAME} >> ~/.ssh/known_hosts 2>/dev/null
# Format namenode if it hasn't been formatted
if [ ! -d "/data/hadoop/hdfs/namenode/current" ]; then
    echo "Formatting namenode..."
    $HADOOP_HOME/bin/hdfs namenode -format -force
fi

# Start Hadoop services
echo "Starting Hadoop services..."
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

# Wait for HDFS to be ready
echo "Waiting for HDFS to be ready..."
hdfs dfsadmin -safemode leave
hdfs dfs -chmod 777 /
sleep 5

# Create HBase directory in HDFS if it doesn't exist
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /hbase

# Start HBase
echo "Starting HBase..."
$HBASE_HOME/bin/start-hbase.sh
# Wait for HBase to be ready
echo "Waiting for HBase to be ready..."
sleep 5
hbase thrift start &
echo "All services started. Hadoop Web UI: http://localhost:9870, HBase Web UI: http://localhost:16010"

# Keep container running
tail -f $HADOOP_HOME/logs/*.log $HBASE_HOME/logs/*.log