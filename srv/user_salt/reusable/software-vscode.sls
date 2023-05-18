install-vscode-key:
  file.managed:
    - name: /etc/apt/keyrings/packages.microsoft.asc
    - makedirs: True
    - source: https://packages.microsoft.com/keys/microsoft.asc
    - skip_verify: True
  cmd.run:
    - name: gpg --dearmor --output /etc/apt/keyrings/packages.microsoft.gpg < /etc/apt/keyrings/packages.microsoft.asc
    - creates: /etc/apt/keyrings/packages.microsoft.gpg

install-vscode-repo:
  pkgrepo.managed:
    - humanname: VSCode
    - name: deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/vscode.list
    - gpgcheck: 1
    - aptkey: False
  cmd.run:
    - name: sudo apt update

install-vscode:
  cmd.run:
    - name: sudo apt install code

