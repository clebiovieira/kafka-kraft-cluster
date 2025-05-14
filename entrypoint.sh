#!/bin/sh
if [ ! -f "/kafka/data/meta.properties" ]; then
  echo "Initializing storage for KRaft mode..."
  /opt/kafka/bin/kafka-storage.sh format -t "$CLUSTER_ID" -c /kafka/config/kraft.properties --ignore-formatted
fi
exec /opt/kafka/bin/kafka-server-start.sh /kafka/config/kraft.properties