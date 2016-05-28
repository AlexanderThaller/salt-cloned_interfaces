{% set datamap = salt['pillar.get']('cloned_interfaces') %}

{% if datamap.interfaces is defined %}
cloned_interfaces.interfaces-config:
  file.managed:
    - name: '/etc/rc.conf.d/network'
    - source: 'salt://cloned_interfaces/files/FreeBSD_network'
    - mode: '0644'
    - user: 'root'
    - group: 'wheel'
    - template: 'jinja'
    - require:
      - test: 'cloned_interfaces.pillar_defined'

{% for interface, args in datamap.interfaces.items() %}
cloned_interfaces.interfaces.{{ interface }}.create:
  cmd.run:
    - name: 'ifconfig {{ args['cloned_interfaces'] }} create'
    - unless: 'ifconfig {{ args['cloned_interfaces'] }}'
    - require:
      - test: 'cloned_interfaces.pillar_defined'

cloned_interfaces.interfaces.{{ interface }}.create_alias:
  cmd.wait:
    - name: 'ifconfig {{ args['cloned_interfaces'] }} alias {{ args['inet'] }} netmask {{ args['netmask'] }} up'
    - require:
      - cmd: 'cloned_interfaces.interfaces.{{ interface }}.create'
      - test: 'cloned_interfaces.pillar_defined'
    - watch:
      - cmd: 'cloned_interfaces.interfaces.{{ interface }}.create'
{% endfor %}
{% endif %}
