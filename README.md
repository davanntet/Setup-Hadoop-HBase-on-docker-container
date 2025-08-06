# Hadoop HDFS and HBase Docker Setup

This repository contains Docker configurations for setting up Hadoop HDFS and HBase in different deployment scenarios.

## Directory Structure

- `single/`: Contains a single Docker container with both Hadoop and HBase
- `hadoop/`: Contains separate Hadoop container configuration  
- `hbase/`: Contains separate HBase container configuration
- `config`: Environment configuration file for docker-compose
- `docker-compose.yaml`: Multi-container orchestration file

## Deployment Options

### Option 1: Single Container (All-in-One)

This option runs Hadoop HDFS and HBase in a single container.

```bash
# Build and run the single container
cd single
docker build -t hadoop-hbase-single .
docker run -p 9870:9870 -p 16010:16010 -p 8088:8088 -p 2181:2181 hadoop-hbase-single
```

**Ports exposed:**
- 9870: Hadoop NameNode Web UI
- 16010: HBase Master Web UI  
- 8088: YARN ResourceManager Web UI
- 2181: ZooKeeper

### Option 2: Multi-Container with Docker Compose

This option runs Hadoop and HBase components in separate containers.

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# Stop all services
docker-compose down
```

**Services included:**
- namenode: Hadoop NameNode
- datanode: Hadoop DataNode
- resourcemanager: YARN ResourceManager
- nodemanager: YARN NodeManager
- zookeeper: ZooKeeper for HBase
- hbase-master: HBase Master
- hbase-regionserver: HBase RegionServer

## Web Interfaces

After starting the services, you can access:

- **Hadoop NameNode UI**: http://localhost:9870
- **YARN ResourceManager UI**: http://localhost:8088  
- **HBase Master UI**: http://localhost:16010

## Basic Usage

### Hadoop HDFS Commands

```bash
# Enter the container
docker exec -it <container_name> bash

# Check HDFS status
hdfs dfsadmin -report

# Create a directory
hdfs dfs -mkdir /test

# Upload a file
hdfs dfs -put /etc/hosts /test/

# List files
hdfs dfs -ls /test

# Download a file
hdfs dfs -get /test/hosts ./downloaded_hosts
```

### HBase Commands

```bash
# Enter HBase shell
hbase shell

# Create a table
create 'test_table', 'cf1'

# Put data
put 'test_table', 'row1', 'cf1:col1', 'value1'

# Get data
get 'test_table', 'row1'

# Scan table
scan 'test_table'

# Exit HBase shell
exit
```

## Configuration Files

### Hadoop Configuration
- `core-site.xml`: Core Hadoop configuration
- `hdfs-site.xml`: HDFS-specific configuration
- `yarn-site.xml`: YARN configuration
- `mapred-site.xml`: MapReduce configuration
- `hadoop-env.sh`: Environment variables

### HBase Configuration
- `hbase-site.xml`: HBase main configuration
- `hbase-env.sh`: HBase environment variables

## Troubleshooting

### Common Issues

1. **Containers fail to start**: Check if ports are already in use
2. **HBase can't connect to HDFS**: Ensure namenode is running and accessible
3. **Permission denied**: Make sure the hadoop and hbase processes have proper permissions

### Logs

```bash
# View container logs
docker logs <container_name>

# View specific service logs in multi-container setup
docker-compose logs namenode
docker-compose logs hbase-master
```

### Reset Data

To reset all data and start fresh:

```bash
# For single container
docker volume prune

# For multi-container setup
docker-compose down -v
docker-compose up -d
```

## Customization

### Scaling

To add more DataNodes or RegionServers, modify the `docker-compose.yaml`:

```yaml
# Add more datanodes
datanode2:
  image: apache/hadoop:3
  command: ["hdfs", "datanode"]
  env_file:
    - ./config

# Add more regionservers  
hbase-regionserver2:
  build: ./hbase
  depends_on:
    - hbase-master
  env_file:
    - ./config
  command: ["hbase", "regionserver", "start"]
```

### Memory Configuration

Adjust memory settings in the configuration files:
- YARN: `yarn-site.xml` 
- MapReduce: `mapred-site.xml`
- HBase: `hbase-env.sh`

## Security Notes

⚠️ **Warning**: These configurations are for development/testing purposes only. For production:

1. Enable Kerberos authentication
2. Configure SSL/TLS
3. Set proper user permissions
4. Use external ZooKeeper cluster
5. Configure proper resource limits
6. Enable audit logging
