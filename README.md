#Use singularity image

```bash
singularity instance start \
  --bind $(mktemp -d run/meerkat_XXXX):/run \
  --bind dropbear/:/etc/dropbear \
  --bind log/:/usr/local/spark/logs \
  --bind work/:/usr/local/spark/work \
  halvade.sif halvade-single

  # start spark inside the started image
  singularity exec instance://halvade-single /usr/local/spark/sbin/start-all.sh

  # if pwless ssh doesn't work, you can specify the used key:
  # shell inside the started image
  singularity shell instance://halvade-single
  # set the SPARK_SSH_OPTS inside the shell
  SPARK_SSH_OPTS="$SPARK_SSH_OPTS -i /home/ddecap/.ssh/pwless_rsa"
  /usr/local/spark/sbin/start-all.sh
  exit; # get out of the shell

  # different solution -> bashrc file is sourced in the same directory for environment!


```
# extra variables to use in script:
```bash
HALVADE_HOME
HALVADE_OPTS="-option0 value --option1 value -option2"
RESOURCES # should have all these options: --driver-memory ${DRIVER_MEM} --executor-memory ${EXECUTOR_MEMORY} --executor-cores ${EXECUTOR_CORES} --conf spark.task.cpus=${TASK_CPUS} --conf spark.executor.memoryOverhead=${OVERHEAD_MEMORY}

SPARK_SSH_OPTS # can add -i here if pwless_rsa is not found
HADOOP_SSH_OPTS
```


#Install locally without the singularity image:

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
