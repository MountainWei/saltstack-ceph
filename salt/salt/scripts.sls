{% import 'ceph/global_vars.jinja' as conf with context -%}
{% set host = salt['config.get']('host') -%}
{% set roles = salt['pillar.get']('nodes:' + host + ':roles') -%}

{% if 'ceph-deploy' in roles %}
create ceph_files dir:
  file.directory:
    - name: /home/{{conf.ceph_user}}/ceph_files/
    - mode: 755
    - user: {{conf.ceph_user}}
    - unless: test -d /home/{{conf.ceph_user}}/ceph_files/

purge_ceph_scripts:
  file.managed:
    - name: /home/{{conf.ceph_user}}/ceph_files/purge_ceph.sh
    - source: salt://files/purge_ceph.sh
    - user: {{conf.ceph_user}}
    - group: {{conf.ceph_user}}
    - mode: 744

ssh_scripts:
  file.managed:
    - source: salt://files/auto_ssh.sh
    - name: /home/{{conf.ceph_user}}/ceph_files/auto_ssh.sh
    - user: {{conf.ceph_user}}
    - group: {{conf.ceph_user}}
    - mode: 744
{% endif %}
