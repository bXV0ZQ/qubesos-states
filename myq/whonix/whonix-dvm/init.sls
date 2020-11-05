{% load_yaml as conf %}
netvm: sys-whonix
appmenus: True
{% endload%}

{% include 'myq/qubes/dvmtemplate.sls' with context %}
