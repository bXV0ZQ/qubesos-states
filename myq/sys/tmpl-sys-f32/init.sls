{% load_yaml as conf %}
source: fedora-32
forDispVM: True
{% endload %}

{% include 'myq/qubes/template.sls' with context %}
