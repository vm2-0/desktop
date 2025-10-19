#!/bin/bash

# Agent supervisor script - monitors parent and kills agent if parent dies
# Usage: ./agent_supervisor.sh <parent_pid> <agent_executable>

set -e

PARENT_PID="$1"
AGENT_EXECUTABLE="$2"

if [ -z "$PARENT_PID" ] || [ -z "$AGENT_EXECUTABLE" ]; then
    echo "Usage: $0 <parent_pid> <agent_executable>"
    exit 1
fi

echo "Starting agent supervisor - Parent PID: $PARENT_PID"
echo "Agent executable: $AGENT_EXECUTABLE"

# Start the agent in the background
"$AGENT_EXECUTABLE" &
AGENT_PID=$!

echo "Agent started with PID: $AGENT_PID"

# Set up signal handlers
cleanup() {
    echo "Supervisor received signal, killing agent $AGENT_PID"
    kill "$AGENT_PID" 2>/dev/null || true
    exit 0
}

trap cleanup SIGTERM SIGINT SIGHUP

# Monitor parent process directly in main loop
echo "Starting parent process monitoring..."
while true; do
    # Check if agent is still running
    if ! kill -0 "$AGENT_PID" 2>/dev/null; then
        echo "Agent process $AGENT_PID died, exiting supervisor"
        exit 0
    fi
    
    # Check if parent is still running
    if ! ps -p "$PARENT_PID" > /dev/null 2>&1; then
        echo "Parent process $PARENT_PID died, killing agent $AGENT_PID"
        kill "$AGENT_PID" 2>/dev/null || true
        exit 0
    fi
    
    sleep 1
done