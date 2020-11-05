{% from 'myq/qubes/macros.j2' import appvm_id with context %}

{% load_yaml as conf %}
name: dev-phone
volume: {{ 10 * 1024 * 1024 * 1024 }}
tags:
  - android
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}
