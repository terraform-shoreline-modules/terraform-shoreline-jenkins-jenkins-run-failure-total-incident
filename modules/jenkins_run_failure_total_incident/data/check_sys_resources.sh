

#!/bin/bash



# Check memory usage

memory=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')

if (( $(echo "$memory > 80.00" |bc -l) )); then

    echo "WARNING: Memory usage is high. Current usage: $memory"

else

    echo "Memory usage is normal. Current usage: $memory"

fi



# Check disk space

disk=$(df -h / | awk '{print $5}' | tail -n 1 | cut -d'%' -f1)

if (( "$disk" > 80 )); then

    echo "WARNING: Disk space is low. Current usage: $disk%"

else

    echo "Disk space usage is normal. Current usage: $disk%"

fi



# Check network connectivity

ping -c 4 ${JENKINS_SERVER_ADDRESS} > /dev/null 2>&1

if [ $? -eq 0 ]; then

    echo "Jenkins server is reachable"

else

    echo "ERROR: Jenkins server is not reachable"

fi



# Check Jenkins log files for errors

if grep -q "ERROR" /var/log/jenkins/jenkins.log; then

    echo "ERROR: Jenkins log files contain errors"

else

    echo "Jenkins log files do not contain errors"

fi