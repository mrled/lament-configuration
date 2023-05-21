template-micahrl-clone:
  qvm.clone:
    - name: micahrl-template-DEV
    - source: debian-11

template-micahrl-prefs:
  qvm.prefs:
    - name: micahrl-template-DEV
    #- require:
    #  - clone
    - memory: 4096
    - vcpus: 2
    - netvm: sys-firewall
    - label: purple

