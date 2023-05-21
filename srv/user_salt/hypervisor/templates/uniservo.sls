template-uniservo-clone:
  qvm.clone:
    - name: uniservo-template
    - source: debian-11

template-uniservo-prefs:
  qvm.prefs:
    - name: uniservo-template
    - netvm: sys-firewall
    - label: green
    - include-in-backups: false
