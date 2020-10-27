{% from 'myq/qubes/macros.j2' import appvm_id with context %}

{% load_yaml as conf %}
name: dev-phone
volume: {{ 10 * 1024 * 1024 * 1024 }}
{% endload%}

{% include 'myq/qubes/appvm.sls' with context %}

{{ appvm_id(conf.name) }}-adb-connect:
  file.accumulated:
    - name: tcp_connections
    - filename: /etc/qubes-rpc/policy/qubes.ConnectTCP
    - text: '{{ conf.name }} @default allow,target={{ pillar['roles']['usbvm'] }}'
    - require:
      - qvm: {{ appvm_id(conf.name) }}
    - require_in:
      - file: qubesrpc-tcp-connect

{{ appvm_id(conf.name) }}-remote-adb-start-policy:
  file.accumulated:
    - name: remote_adb_policy_sources
    - filename: /etc/qubes-rpc/policy/android.dev.StartRemoteADB
    - text: '{{ conf.name }}'
    - require:
      - qvm: {{ appvm_id(conf.name) }}
    - require_in:
      - file: android-dev-qubes-rpc-remote-adb-start-policy

{{ appvm_id(conf.name) }}-remote-adb-stop-policy:
  file.accumulated:
    - name: remote_adb_policy_sources
    - filename: /etc/qubes-rpc/policy/android.dev.StopRemoteADB
    - text: '{{ conf.name }}'
    - require:
      - qvm: {{ appvm_id(conf.name) }}
    - require_in:
      - file: android-dev-qubes-rpc-remote-adb-stop-policy
