pf.config:
  file.managed:
    - name: '/etc/pf.conf'
    - source: 'salt://pf/files/pf.conf'
    - template: 'jinja'

pf.service:
  service.running:
    - name: 'pf'
    - reload: True
    - enable: True
    - require:
      - file: 'pf.config'
    - watch:
      - file: 'pf.config'
