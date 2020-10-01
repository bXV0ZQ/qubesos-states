{% load_yaml as conf %}
source: fedora-32
{% endload %}

{% include 'myq/qubes/template.sls' with context %}
