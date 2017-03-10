{%- from "tftpd/map.jinja" import server with context %}
{%- if server.enabled %}

tftpd_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/etc/xinetd.d/tftp:
  file.managed:
  - source: salt://tftpd/files/xinetd.tftp
  - require:
    - pkg: tftpd_packages

# create_tftpboot_folder:
#   cmd.run:
#   - names:
#     - mkdir -p /tftpboot/ && chown ironic:ironic /tftpboot/ && chmod 755 /tftpboot
#   - require:
#     - file: /etc/xinetd.d/tftp

tftpd-hpa:
  service.dead:
    - name: tftpd-hpa
    - enable: False
    - watch:
      - pkg: tftpd_packages

/tftpboot:
  file.recurse:
  - source: salt://tftpd/files/tftpboot
  - user: ironic
  - group: ironic
  

xinetd:
  service.running:
    - enable: true
    - watch:
      - file: /etc/xinetd.d/tftp
      - file: /tftpboot 
    
{%- endif %}
