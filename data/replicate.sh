#!/bin/bash

# This file is very closely based on the tile.openstreetmap.org update script,
# but calls imposm instead
# https://github.com/openstreetmap/chef/blob/master/cookbooks/tile/templates/default/replicate.erb
# Licensed under the Apache 2.0 License
# Before running updates, the replication needs to be set up with the timestamp
# set to the day of the latest planet dump. Setting to midnight ensures we get
# conistent data after first run. osmosis --read-replication-interval-init is
# used to initially create the state file

# Assumptions
# The replication directory is /home/ubuntu/replicate
# The mapping file is CartoDB-basemaps/data/imposm3_mapping.json
# The presistent imposm3 cache is imposm3_cache
# imposm3/imposm3 has a working imposm3 binary
# configuration.txt and state.txt are already set up


REPLICATE_HOME=/home/ubuntu/replicate
IMPOSM3_MAPPING="${REPLICATE_HOME}/CartoDB-basemaps/data/imposm3_mapping.json"
IMPOSM3_CACHE="${REPLICATE_HOME}/imposm3_cache"

# Define exit handler
function onexit {
    [ -f state-prev.txt ] && mv state-prev.txt state.txt
}

# Change to the replication state directory
cd $REPLICATE_HOME

# Send output to the log
exec > replicate.log 2>&1

# Install exit handler
trap onexit EXIT

# Read in initial state
. state.txt

# Loop indefinitely
while true
do
    # Work out the name of the next file
    file="changes-${sequenceNumber}.osm.gz"

    # Save state file so we can rollback if an error occurs
    cp state.txt state-prev.txt

    # Fetch the next set of changes
    osmosis --read-replication-interval --simc --write-xml-change file="${file}" compressionMethod="gzip"

    # Check for errors
    if [ $? -eq 0 ]
    then
        # Enable exit on error
        set -e

        # Remember the previous sequence number
        prevSequenceNumber=$sequenceNumber

        # Read in new state
        . state.txt

        # Did we get any new data?
        if [ "${sequenceNumber}" == "${prevSequenceNumber}" ]
        then
            # Log the lack of data
            echo "No new data available. Sleeping..."

            # Remove file, it will just be an empty changeset
            rm ${file}

            # No need to rollback now
            rm state-prev.txt

            # Sleep for a short while
            sleep 30
        else
            # Log the new data
            echo "Fetched new data from ${prevSequenceNumber} to ${sequenceNumber} into ${file}"

            # Apply the changes to the database
            imposm3/imposm3 diff -mapping="${IMPOSM3_MAPPING}" \
              -cachedir="${IMPOSM3_CACHE}" -connection="postgis://?prefix=NONE" \
              "${file}"

            # No need to rollback now
            rm state-prev.txt
        fi

        # Delete old downloads
        find . -name 'changes-*.gz' -mmin +300 -exec rm -f {} \;

        # Disable exit on error
        set +e
    else
        # Log our failure to fetch changes
        echo "Failed to fetch changes - waiting a few minutes before retry"

        # Wait five minutes and have another go
        sleep 300
    fi
done
