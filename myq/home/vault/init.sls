{% load_yaml as conf %}
network: False
label: black
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}