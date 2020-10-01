{% from 'myq/qubes/macros.jinja' import appvm_id with context %}

{% load_yaml as conf %}
name: sys-fw
template: tmpl-sys-dvm
label: green
netvm: sys-net-usb
autostart: True
disposable: True
memory: 500
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

{{ appvm_id(conf.name) }}-default-netvn:
  cmd.run:
    - name: qubes-prefs default_netvm {{ conf.name }}
    - unless: test $(qubes-prefs default_netvm 2>/dev/null) = {{ conf.name }}
    - require:
      - qvm: {{ appvm_id(conf.name) }}-extra

{{ appvm_id(conf.name) }}-updatevm:
  cmd.run:
    - name: qubes-prefs updatevm {{ conf.name }}
    - unless: test $(qubes-prefs updatevm 2>/dev/null) = {{ conf.name }}
    - require:
      - qvm: {{ appvm_id(conf.name) }}-extra
