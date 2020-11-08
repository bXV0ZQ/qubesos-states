{% load_yaml as conf %}
volume: {{ 10 * 1024 * 1024 * 1024 }}
tags:
  - android
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}
