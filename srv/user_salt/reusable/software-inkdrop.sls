get-inkdrop:
  file.managed:
    - name: /tmp/inkdrop.deb
    - source: https://api.inkdrop.app/download/linux/deb
    - skip_verify: True # This just means we don't have to specify the hash of the file here
install-inkdrop:
  cmd.run:
    - name: sudo dpkg -i /tmp/inkdrop.deb
install-inkdrop-missing-deps-after-dpkg:
  cmd.run:
    - name: sudo apt-get -f install # Installs any missing deps after the dpkg cmd
remove-inkdrop-deb:
  cmd.run:
    - name: rm /tmp/inkdrop.deb

