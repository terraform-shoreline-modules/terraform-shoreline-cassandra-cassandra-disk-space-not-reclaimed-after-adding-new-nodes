

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