uniservo-clone:
  qvm.clone:
    - name: uniservo
    - source: uniservo-template

uniservo-prefs:
  qvm.prefs:
    - name: uniservo
    - netvm: sys-firewall
    - label: green
    - include-in-backups: false

# This magic number is 50 GiB in bytes
# We can use something like "50G" instead,
# but if we do, the first run succeeds, and subsequent runs fail.
# How do you find this magic number?
# You can calculate it yourself, or just create it in the GUI and copy it from
#   qvm-volume i QUBE:private
# <https://groups.google.com/g/qubes-users/c/_QpI0zrt2nY>
qvm-volume extend uniservo:private 53687091200:
  cmd.run
