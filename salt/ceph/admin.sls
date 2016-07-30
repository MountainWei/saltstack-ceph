{% import 'ceph/global_vars.jinja' as conf with context -%}
{% set ip = salt['network.ip_addrs'](conf.mon_interface)[0] -%}
{% set mon_hosts = conf.monitors|join(' ') %}
{% set osd_hosts = conf.osds|join(' ') %}

include:
  - .ceph

ceph-purge:
  cmd.run:
    - name: /home/{{conf.ceph_user}}/ceph_files/purge_ceph.sh {{conf.host}} {{mon_hosts}} {{osd_hosts}}
    - onlyif: test -f /home/{{conf.ceph_user}}/purge_ceph.sh
    - cwd: /home/{{conf.ceph_user}}/{{conf.cluster}}/
    - user: {{conf.ceph_user}}
    - onlyif: test -d /home/{{conf.ceph_user}}/{{conf.cluster}}/
    - require:
      - pkg: install ceph-deploy

delete mycluster directory:
  cmd.run:
    - name: rm -rf /home/{{conf.ceph_user}}/{{conf.cluster}}/
    - user: {{conf.ceph_user}}
    - onlyif: test -d /home/{{conf.ceph_user}}/{{conf.cluster}}/

create mycluster directory:
  file.directory:
    - name: /home/{{conf.ceph_user}}/{{conf.cluster}}
    - user: {{conf.ceph_user}}
    - group: {{conf.ceph_user}}
    - mode: 755
    - makedirs: True

create cluster:
  cmd.run:
    - name: /usr/bin/ceph-deploy new {{conf.monitors[0]}}
    - cwd: /home/{{conf.ceph_user}}/{{conf.cluster}}/
    - user: saltstack
    - require:
      - file: create mycluster directory

reload ceph config file:
  file.managed:
    - name: /home/{{conf.ceph_user}}/{{conf.cluster}}/ceph.conf
    - source: salt://files/ceph.conf
    - user: {{conf.ceph_user}}
    - group: {{conf.ceph_user}}
    - mod: 0644
    - template: jinja
    - require:
      - cmd: create cluster

install ceph:
  cmd.run:
    - name: ceph-deploy install {{conf.host}} {{mon_hosts}} {{osd_hosts}} 
    - cwd: /home/{{conf.ceph_user}}/{{conf.cluster}}/
    - user: {{conf.ceph_user}}

gather keys:
  cmd.run:
    - name: ceph-deploy mon create-initial
    - user: saltstack
    - cwd: /home/{{conf.ceph_user}}/{{conf.cluster}}/

{% for osd in conf.osds %}
{% set osd_location = pillar['ceph']['osd_location'][osd] %}
prepare and activate {{osd}}:
  cmd.run:
    - name: |
       ceph-deploy osd prepare {{osd}}:{{osd_location}}
       ceph-deploy osd activate {{osd}}:{{osd_location}}
    - user: {{conf.ceph_user}}
    - cwd: /home/{{conf.ceph_user}}/{{conf.cluster}}/
{% endfor %}

copy conf and key:
  cmd.run:
    - name: ceph-deploy admin {{conf.host}} {{mon_hosts}} {{osd_hosts}}
    - cwd: /home/{{conf.ceph_user}}/{{conf.cluster}}/
    - user: {{conf.ceph_user}}

change admin.key permission:
  cmd.run:
    - name: chmod +r /etc/ceph/ceph.client.admin.keyring

