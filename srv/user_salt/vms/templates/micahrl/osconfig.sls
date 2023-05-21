install-packages-base:
  cmd.run:
    - name: sudo apt update
    # This is slow, comment when in development
    #- name: sudo apt upgrade -y
  pkg.installed:
    - pkgs:
      - git
      - jq
      - python3
      - python3-pip
      - python3-venv
      - rpm
      - tree
      - vim
