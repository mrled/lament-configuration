# This doesn't get updates :( but it does get the latest version on every highstate for the template
get-vscodium:
  cmd.run:
    - name: /usr/local/bin/get-gh-release --outfile /tmp/codium.deb VSCodium/vscodium "codium.*amd64.deb$"
    - creates: /tmp/codium.deb

install-vscodium:
  cmd.run:
    - name: sudo dpkg -i /tmp/codium.deb
install-vscodium-deps-after-dpkg-cmd:
  cmd.run:
    - name: sudo apt-get -f install # Installs any missing deps after the dpkg cmd
remove-vscodium-deb:
  cmd.run:
    - name: rm /tmp/codium.deb

