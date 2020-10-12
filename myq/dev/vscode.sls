include:
  - myq.vscode.appvm.config

# vscode settings

vscode-settings-telemetry:
  file.accumulated:
    - name: code_settings
    - filename: /home/user/.config/Code/User/settings.json
    - text:
      - '"telemetry.enableTelemetry": false'
      - '"telemetry.enableCrashReporter": false'
    - require_in:
      - file: vscode-settings

vscode-settings-ext-icons:
  file.accumulated:
    - name: code_settings
    - filename: /home/user/.config/Code/User/settings.json
    - text: '"workbench.iconTheme": "material-icon-theme"'
    - require:
      - cmd: vscode-ext-pkief.material-icon-theme
    - require_in:
      - file: vscode-settings

vscode-settings-ext-asciidoctor:
  file.accumulated:
    - name: code_settings
    - filename: /home/user/.config/Code/User/settings.json
    - text: '"asciidoc.wkhtmltopdf_path": "/usr/bin/wkhtmltopdf"'
    - require:
      - cmd: vscode-ext-asciidoctor.asciidoctor-vscode
    - require_in:
      - file: vscode-settings

vscode-settings-saltstack:
  file.accumulated:
    - name: code_settings_files_associations
    - filename: /home/user/.config/Code/User/settings.json
    - text:
      - '"*.sls": "yaml"'
      - '"*.top": "yaml"'
    - require_in:
      - file: vscode-settings
