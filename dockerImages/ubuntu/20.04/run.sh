#!/bin/bash

# Starting up services
service docker start
service ssh start

# while loop to hold the container in a running state
while true; do sleep 10; done
