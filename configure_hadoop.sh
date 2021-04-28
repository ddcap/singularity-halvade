#!/bin/bash

# determine variables if not yet defined
if [[ -z $UUID ]]; then UUID=$(uuidgen) fi
if [[ -z $WORKDIR ]]; then WORKDIR=`pwd` fi
mkdir -p ${WORKDIR}/${UUID}
if [[ -z $HOSTNAME ]]; then HOSTNAME=`hostname -f` fi
if [[ -z $DEFAULT_FS ]]; then
  if [[ -z $USE_HDFS ]]; then
    DEFAULT_FS="hdfs://$HOSTNAME:9000"
  else
    DEFAULT_FS="file:///"
  fi
fi
if [[ -z $DFS_NAMENODE ]]; then
  DFS_NAMENODE="${WORKDIR}/${UUID}/nameNode"
fi
if [[ -z $DFS_DATANODE ]]; then
  DFS_DATANODE="${WORKDIR}/${UUID}/dataNode"
fi
if [[ -z $DFS_REPLICATION ]]; then
  DFS_REPLICATION=1
fi
if [[ -z $RESOURCE_MEMORY ]]; then
  MEM_KB=`grep MemTotal /proc/meminfo | awk '{print $2}'` # in KB
  RESOURCE_MEMORY=$((MEM_KB/1024)) # in MB
fi
if [[ -z $MAXIMUM_MEMORY ]]; then
  MAXIMUM_MEMORY=$RESOURCE_MEMORY
fi
if [[ -z $MINIMUM_MEMORY ]]; then
  MINIMUM_MEMORY=1024
fi
if [[ -z $RESOURCE_CPU ]]; then
  RESOURCE_CPU=`cat /proc/cpuinfo | grep processor | wc -l`
fi
if [[ -z $MAXIMUM_CPU ]]; then
  MAXIMUM_CPU=$RESOURCE_CPU
fi
if [[ -z $LOG_DIRECTORY ]]; then
  LOG_DIRECTORY="${WORKDIR}/${UUID}/logs"
fi
if [[ -z $LOCAL_DIRS ]]; then
  LOCAL_DIRS="${WORKDIR}/${UUID}/nm-local-dir"
fi
if [[ -z $HADOOP_CONF_DIR ]]; then
  HADOOP_CONF_DIR="${WORKDIR}/${UUID}/hadoopconf"
fi

# adjust the hadoop configuration files
cp -R /usr/local/hadoop/etc/hadoop/ $HADOOP_CONF_DIR
# core-site.xml
sed -i "s/DEFAULT_FS/$DEFAULT_FS/g" $HADOOP_CONF_DIR/core-site.xml
# hdfs-site.xml
sed -i "s/DFS_NAMENODE/$DFS_NAMENODE/g" $HADOOP_CONF_DIR/hdfs-site.xml
sed -i "s/DFS_DATANODE/$DFS_DATANODE/g" $HADOOP_CONF_DIR/hdfs-site.xml
sed -i "s/DFS_REPLICATION/$DFS_REPLICATION/g" $HADOOP_CONF_DIR/hdfs-site.xml
# yarn-site.xml
sed -i "s/HOSTNAME/$HOSTNAME/g" yarn-site.xml
sed -i "s/RESOURCE_MEMORY/$RESOURCE_MEMORY/g" $HADOOP_CONF_DIR/yarn-site.xml
sed -i "s/MAXIMUM_MEMORY/$MAXIMUM_MEMORY/g" $HADOOP_CONF_DIR/yarn-site.xml
sed -i "s/MINIMUM_MEMORY/$MINIMUM_MEMORY/g" $HADOOP_CONF_DIR/yarn-site.xml
sed -i "s/RESOURCE_CPU/$RESOURCE_CPU/g" $HADOOP_CONF_DIR/yarn-site.xml
sed -i "s/MAXIMUM_CPU/$MAXIMUM_CPU/g" $HADOOP_CONF_DIR/yarn-site.xml
sed -i "s/LOG_DIRECTORY/$LOG_DIRECTORY/g" $HADOOP_CONF_DIR/yarn-site.xml
sed -i "s/LOCAL_DIRS/$LOCAL_DIRS/g" $HADOOP_CONF_DIR/yarn-site.xml

export HADOOP_CONF_DIR
