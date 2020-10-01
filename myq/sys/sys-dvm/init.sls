{% load_yaml as conf %}
label: gray
network: False
internal: True
{% endload%}

{% include 'myq/qubes/dvmtemplate.sls' with context %}
