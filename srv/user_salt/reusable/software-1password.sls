install-1password-policy:
  file.managed:
    - name: /etc/debsig/policies/AC2D62742012EA22/1password.pol
    - makedirs: True
    - source: https://downloads.1password.com/linux/debian/debsig/1password.pol
    - skip_verify: True

install-1password-keyring:
  file.managed:
    - name: /usr/share/keyrings/1password.asc
    - makedirs: True
    - source: https://downloads.1password.com/linux/keys/1password.asc
    - skip_verify: True
  cmd.run:
    # ... the same file gets decrypted to two places for some reason?
    - name: gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg < /usr/share/keyrings/1password.asc
    - creates: /usr/share/keyrings/1password-archive-keyring.gpg

install-1password-debsig:
  file.directory:
    - name: /usr/share/debsig/keyrings/AC2D62742012EA22
    - makedirs: True
  cmd.run:
    - name: cp /usr/share/keyrings/1password-archive-keyring.gpg /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    - creates: /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

install-repo-1password:
  pkgrepo.managed:
    - humanname: 1Password
    - name: deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/1password.list
    - gpgcheck: 1
    - aptkey: False
  cmd.run:
    - name: apt update

install-1password:
  cmd.run:
    - name: apt install -y 1password

