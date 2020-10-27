{% from 'myq/qubes/macros.j2' import appvm_id with context %}

{% load_yaml as conf %}
name: sys-net-usb
template: sys-net-usb-dvm
network: False
autostart: True
disposable: True
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

#
# Network related configuration
#

# Configure Qubes RPC policy for updates
{{ appvm_id(conf.name) }}-updates-proxy-policy:
  file.managed:
    - name: /etc/qubes-rpc/policy/qubes.UpdatesProxy
    - source: salt://myq/sys/sys-net-usb/files/qubes-rpc-policy.update-proxy.j2
    - template: jinja
    - context:
        netvm: {{ conf.name }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - qvm: {{ appvm_id(conf.name) }}-extra

# Configure as clock VM
{{ appvm_id(conf.name) }}-clockvm:
  cmd.run:
    - name: qubes-prefs clockvm {{ conf.name }}
    - unless: test $(qubes-prefs clockvm 2>/dev/null) = {{ conf.name }}
    - require:
      - qvm: {{ appvm_id(conf.name) }}-extra

#
# USB related configuration
#

# Make sure input proxy is installed on dom0
{{ appvm_id(conf.name) }}-input-proxy:
  pkg.installed:
    - name: qubes-input-proxy

# Configure Qubes RPC policy for mouse management
{{ appvm_id(conf.name) }}-input-proxy-policy:
  file.managed:
    - name: /etc/qubes-rpc/policy/qubes.InputMouse
    - source: salt://myq/sys/sys-net-usb/files/qubes-rpc-policy.input-mouse.j2
    - template: jinja
    - context:
        usbvm: {{ conf.name }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - qvm: {{ appvm_id(conf.name) }}-extra
      - pkg: {{ appvm_id(conf.name) }}-input-proxy
