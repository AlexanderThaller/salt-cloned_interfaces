cloned_interfaces.pillar_defined:
  test.check_pillar:
    - dictionary:
      - 'cloned_interfaces'
      - 'cloned_interfaces:interfaces'

include:
  - '.init_{{ salt['grains.get']('os_family') }}'
