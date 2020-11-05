{% from 'myq/qubes/macros.j2' import appvm_id with context %}

{% load_yaml as conf %}
name: sys-net-usb
template: sys-net-usb-dvm
network: False
autostart: True
disposable: True
tags:
  - netvm
  - usbvm
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}

{{ appvm_id(conf.name) }}-extra:
  qvm.vm:
    - name: {{ conf.name }}
    - prefs:
      - virt_mode: hvm
      - provides-network: True
    - features:
      - enable:
        - service.clocksync
        - appmenus-dispvm
      - disable:
        - service.meminfo-writer
    - require:
      - qvm: {{ appvm_id(conf.name) }}

{{ appvm_id(conf.name) }}-pci:
  qvm.vm:
    - name: {{ conf.name }}
    - prefs:
      - pcidevs: {{ (salt['grains.get']('pci_net_devs', []) + salt['grains.get']('pci_usb_devs', [])) | yaml }}
      - pci_strictreset: False
    - unless: qvm-check --quiet --running {{ conf.name }} 2> /dev/null
    - require:
      - qvm: {{ appvm_id(conf.name) }}-extra
