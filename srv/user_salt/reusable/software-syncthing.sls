install-syncthing:
  file.managed:
    - name: /usr/share/keyrings/syncthing-archive-keyring.gpg
    - makedirs: True
    - source: https://syncthing.net/release-key.gpg
    - skip_verify: True # This just means we don't have to specify the hash of the file here
  pkgrepo.managed:
    - humanname: Syncthing
    - name: deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable
    - dist: syncthing
    - file: /etc/apt/sources.list.d/syncthing.list
    - gpgcheck: 1
    - aptkey: False
  cmd.run:
    - name: sudo apt update
  pkg.latest:
    - name: syncthing

