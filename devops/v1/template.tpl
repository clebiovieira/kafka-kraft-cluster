# template.tpl
apiVersion: "kafka.jikkou.io/v1beta2"
kind: "KafkaTopicList"
metadata:
  labels:
    managed-by: "jikkou"
items:
{% for topic in values.topics %}
- metadata:
    name: "{{ topic.name }}"
  spec:
    partitions: {{ values.topicPolicies[topic.name].partitions | default(values.topicDefaults.partitions) }}
    replicas: {{ values.topicPolicies[topic.name].replicas | default(values.topicDefaults.replicas) }}
    configs:
      {% set default_configs = values.topicDefaults.configs %}
      {% set topic_configs = values.topicPolicies[topic.name].configs if values.topicPolicies[topic.name] is defined else {} %}
      {% for key, value in default_configs.items() %}
      {{ key }}: {{ topic_configs[key] if key in topic_configs else value }}
      {% endfor %}
      {% for key, value in topic_configs.items() %}
      {% if key not in default_configs %}
      {{ key }}: {{ value }}
      {% endif %}
      {% endfor %}
{% endfor %}
