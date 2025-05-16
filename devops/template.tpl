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
    {% if topic.size is defined %}
    {% set size_profile = values.topicSizeProfiles[topic.size] %}
    partitions: {{ topic.partitions | default(size_profile.partitions) }}
    replicas: {{ topic.replicas | default(size_profile.replicas) }}
    configs:
      {% set default_configs = values.topicDefaults.configs %}
      {% set profile_configs = size_profile.configs if size_profile.configs is defined else {} %}
      {% set topic_configs = topic.configs if topic.configs is defined else {} %}
      
      {% for key, value in default_configs.items() %}
      {{ key }}: {{ topic_configs[key] if key in topic_configs else profile_configs[key] if key in profile_configs else value }}
      {% endfor %}
      
      {% for key, value in profile_configs.items() %}
      {% if key not in default_configs %}
      {{ key }}: {{ topic_configs[key] if key in topic_configs else value }}
      {% endif %}
      {% endfor %}
      
      {% for key, value in topic_configs.items() %}
      {% if key not in default_configs and key not in profile_configs %}
      {{ key }}: {{ value }}
      {% endif %}
      {% endfor %}
    {% else %}
    partitions: {{ topic.partitions | default(values.topicDefaults.partitions) }}
    replicas: {{ topic.replicas | default(values.topicDefaults.replicas) }}
    configs:
      {% set default_configs = values.topicDefaults.configs %}
      {% set topic_configs = topic.configs if topic.configs is defined else {} %}
      
      {% for key, value in default_configs.items() %}
      {{ key }}: {{ topic_configs[key] if key in topic_configs else value }}
      {% endfor %}
      
      {% for key, value in topic_configs.items() %}
      {% if key not in default_configs %}
      {{ key }}: {{ value }}
      {% endif %}
      {% endfor %}
    {% endif %}
{% endfor %}