{%- if pillar.tftpd is defined %}
include:
{%- if pillar.tftpd.server is defined %}
- tftpd.server
{%- endif %}
{%- endif %}
