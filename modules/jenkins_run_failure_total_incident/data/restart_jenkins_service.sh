bash

#!/bin/bash



# Restart the Jenkins service

sudo systemctl restart jenkins



# Sleep for 10 seconds to make sure Jenkins service has restarted successfully

sleep 10



# Verify that the service has started successfully

sudo systemctl status jenkins