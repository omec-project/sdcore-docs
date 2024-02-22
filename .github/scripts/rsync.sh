#!/bin/bash
# SPDX-FileCopyrightText: 2024 the Open Networking Foundation Contributors
# SPDX-License-Identifier: Apache-2.0
#
#
# $1: ssh_login_username
# $2: remote_server_ip
# $3: ssh_port
# $4: source_path
# $5: destination_path
# $6: ssh_private_key_file

# set -euo pipefail

SSH_COMMAND="ssh -p $3 -i $6 -o StrictHostKeyChecking=no"

echo =========================================================================

start_time=$(date)

echo "{start_time}={start_time}" >> $GITHUB_OUTPUT
echo "Start time of synchronization  ->  $start_time"

rsync -e "$SSH_COMMAND" -av $4 $1@$2:$5
if [ $? -ne 0 ]; then
    echo "rsync command failed"
    exit 1
fi

end_time=$(date)

echo "{end_time}={end_time}" >> $GITHUB_OUTPUT
echo "End time of synchronization  ->  $end_time"

echo =========================================================================

exit 0
