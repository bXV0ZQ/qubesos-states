{% from 'myq/qubes/macros.j2' import appvm_id with context %}

{% load_yaml as conf %}
name: sys-fw
template: sys-fw-dvm
label: green
netvm: sys-net-usb
autostart: True
disposable: True
memory: 500
tags:
  - fwvm
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}

{{ appvm_id(conf.name) }}-extra:
  qvm.vm:
    - name: {{ conf.name }}
    - prefs:
      - provides-network: True
    - features:
      - enable:
        - appmenus-dispvm
    - require:
      - qvm: {{ appvm_id(conf.name) }}
