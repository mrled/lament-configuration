install-repo-element:
  file.managed:
    - name: /usr/share/keyrings/element-io-archive-keyring.gpg
    - makedirs: True
    - source: https://packages.element.io/debian/element-io-archive-keyring.gpg
    - skip_verify: True # This just means we don't have to specify the hash of the file here
  pkgrepo.managed:
    - humanname: Element
    - name: deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main
    - dist: default
    - file: /etc/apt/sources.list.d/element.list
    - gpgcheck: 1
    - aptkey: False
  cmd.run:
    - name: sudo apt update
  pkg.latest:
    - name: element-desktop

