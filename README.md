
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra Disk Space Not Reclaimed After Adding New Nodes
---

This incident type occurs when disk space in a Cassandra cluster is not reclaimed after adding new nodes. This can lead to the cluster running out of disk space, causing performance issues or even complete failure. The root cause can vary, but it is often due to misconfigurations or software bugs. It is important to address this issue promptly to prevent data loss and ensure the stability of the Cassandra cluster.

### Parameters
```shell
export HOSTNAME="PLACEHOLDER"

export PATH_TO_CASSANDRA_CONFIG_FILE="PLACEHOLDER"

export NUMBER_OF_EXPECTED_NODES="PLACEHOLDER"

export NUMBER_OF_CURRENT_NODES="PLACEHOLDER"

export PATH_TO_CASSANDRA_HOME="PLACEHOLDER"
```

## Debug

### Check disk usage on all nodes
```shell
ssh ${HOSTNAME} 'df -h'
```

### Check available disk space
```shell
ssh ${HOSTNAME} 'du -sh /var/lib/cassandra/*'
```

### Check if compaction is stalled
```shell
nodetool compactionstats
```

### Check if there are any pending tasks
```shell
nodetool tpstats
```

### Check if there are any errors in the system log
```shell
tail -f /var/log/cassandra/system.log
```

### Check if there are any pending repairs
```shell
nodetool repair -pr
```

### Check if nodetool cleanup has been run
```shell
nodetool cleanup
```

### Check if nodetool scrub has been run
```shell
nodetool scrub
```

### Check if nodetool compact has been run
```shell
nodetool compact
```

## Repair

### Review the Cassandra cluster configuration to ensure that it is properly set up for the number of nodes currently in use and the expected growth of the cluster.
```shell


#!/bin/bash



# Define variables

CASSANDRA_CONFIG_FILE=${PATH_TO_CASSANDRA_CONFIG_FILE}

EXPECTED_NODES=${NUMBER_OF_EXPECTED_NODES}

CURRENT_NODES=${NUMBER_OF_CURRENT_NODES}



# Check if the configuration file exists

if [ ! -f "$CASSANDRA_CONFIG_FILE" ]; then

    echo "Error: Cassandra configuration file not found."

    exit 1

fi



# Check if the number of nodes is correct

if [ "$CURRENT_NODES" -ne "$EXPECTED_NODES" ]; then

    echo "Warning: Current number of nodes does not match expected number of nodes."

fi



# Check if the configuration file is properly set up

if grep -q "^num_tokens: $EXPECTED_NODES$" "$CASSANDRA_CONFIG_FILE"; then

    echo "Cassandra cluster configuration is properly set up."

else

    echo "Error: Cassandra cluster configuration is not properly set up."

    sed -i "s/^num_tokens:.*$/num_tokens: $EXPECTED_NODES/" "$CASSANDRA_CONFIG_FILE"

    echo "Fixed Cassandra cluster configuration."

fi


```

### Run a repair on the Cassandra cluster to clean up any old or unused data that may be taking up disk space.
```shell


#!/bin/bash



# Set the Cassandra home directory

CASSANDRA_HOME=${PATH_TO_CASSANDRA_HOME}



# Stop the Cassandra service

sudo service cassandra stop



# Run the repair command

$CASSANDRA_HOME/bin/nodetool repair -pr



# Start the Cassandra service

sudo service cassandra start


```