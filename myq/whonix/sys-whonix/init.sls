{% from 'myq/qubes/macros.j2' import appvm_id with context %}

{% load_yaml as conf %}
name: sys-whonix
template: whonix-gw-15
label: green
tags:
  - whonixgw
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}

{{ appvm_id(conf.name) }}-extra:
  qvm.vm:
    - name: {{ conf.name }}
    - prefs:
      - provides-network: True
    - require:
      - qvm: {{ appvm_id(conf.name) }}
