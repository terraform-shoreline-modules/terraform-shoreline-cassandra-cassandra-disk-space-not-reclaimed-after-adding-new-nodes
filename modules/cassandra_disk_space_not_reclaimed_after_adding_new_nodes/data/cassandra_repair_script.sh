

#!/bin/bash



# Set the Cassandra home directory

CASSANDRA_HOME=${PATH_TO_CASSANDRA_HOME}



# Stop the Cassandra service

sudo service cassandra stop



# Run the repair command

$CASSANDRA_HOME/bin/nodetool repair -pr



# Start the Cassandra service

sudo service cassandra start