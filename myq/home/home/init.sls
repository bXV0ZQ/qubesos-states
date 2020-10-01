{% load_yaml as conf %}
volume: {{ 30 * 1024 * 1024 * 1024 }}
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}
