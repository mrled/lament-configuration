install-get-gh-release:
  file.managed:
    - name: /opt/local/bin/get-gh-release
    - mode: 0755
    - source: salt://reusable/files/get-gh-release
