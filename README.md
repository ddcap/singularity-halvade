# Use singularity image


Singularity image:
[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/5392)



```bash
singularity instance start \
  --bind $(mktemp -d run/hostname_XXXX):/run \
  --bind dropbear/:/etc/dropbear \
  --bind log/:/usr/local/spark/logs \
  --bind work/:/usr/local/spark/work \
  halvade.sif halvade-single

  # start spark inside the started image
  singularity exec instance://halvade-single /usr/local/spark/sbin/start-all.sh

  # if pwless ssh doesn't work, you can specify the used key in the `bashrc` file in the same directory as your halvade.sif file by adding this line:
  SPARK_SSH_OPTS="$SPARK_SSH_OPTS -i /home/username/.ssh/pwless_rsa"

```

# extra variables to use in script:
```bash
HALVADE_HOME
HALVADE_OPTS="-option0 value --option1 value -option2"
RESOURCES # should have all these options: --driver-memory ${DRIVER_MEM} --executor-memory ${EXECUTOR_MEMORY} --executor-cores ${EXECUTOR_CORES} --conf spark.task.cpus=${TASK_CPUS} --conf spark.executor.memoryOverhead=${OVERHEAD_MEMORY}

SPARK_SSH_OPTS # can add -i here if pwless_rsa is not found
HADOOP_SSH_OPTS
```


# Install locally without the singularity image:

## start Spark without YARN
```bash
# use default settings -> all cpus/memory in spark
start-all.sh
stop-all.sh

#To set memory/CPU per node:
start-master.sh
start-slave.sh spark://node001:7077 -c 6 -m 50 # on every worker node
# stop
stop-slave.sh # on every worker node
stop-master.sh
```

`spark-submit` will need `--master` option to be set to `spark://master:7077` to use the standalone Spark.
