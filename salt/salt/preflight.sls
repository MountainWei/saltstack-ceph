{% import 'ceph/global_vars.jinja' as conf with context %}
{% set host = salt['config.get']('host') -%}
{% set roles = salt['pillar.get']('nodes:' + host + ':roles') -%}
{% set config_ssh = pillar['ssh']['config_ssh'] -%}

{% if config_ssh == 'yes' %}
ssh_config:
  pkg.installed:
    - name: openssh-server

  cmd.run:
    - name: ssh-keygen -t rsa -P "" -f /home/{{conf.ceph_user}}/.ssh/id_rsa
    - cwd: /home/{{conf.ceph_user}}/
    - user: {{conf.ceph_user}}
    - unless: test -f /home/{{conf.ceph_user}}/.ssh/id_rsa
{% endif %}

{% if 'ceph-deploy' in roles %}
{% for ssh_host in conf.ssh_hosts %}
ssh_{{ssh_host}}:
  cmd.run:
    - name: /home/{{conf.ceph_user}}/ceph_files/auto_ssh.sh {{conf.ceph_user}} {{conf.password}} {{ssh_host}}
    - cwd: /home/{{conf.ceph_user}}/
    - user: {{conf.ceph_user}}
    - onlyif: test -d /home/{{conf.ceph_user}}/.ssh/
    - unless: ssh {{conf.ceph_user}}@{{ssh_host}}
{% endfor %}
{% endif %}

sudo_nopasswd:
  cmd.run:
    - name: | 
       echo "{{conf.ceph_user}} ALL = (root) NOPASSWD:ALL" |  tee /etc/sudoers.d/{{conf.ceph_user}}
       chmod 0440 /etc/sudoers.d/{{conf.ceph_user}}
    - unless: test -f /etc/sudoers.d/{{conf.ceph_user}}

{% if conf.host in conf.osds %}
{% set osd_location = pillar['ceph']['osd_location'][conf.host] %}
delete osd location:
  cmd.run:
  - name: rm -rf {{osd_location}}
  - onlyif: test -d {{osd_location}}

create osd location:
  file.directory:
    - name: {{osd_location}}
    - mod: 777
    - unless: test -d {{osd_location}}

chmod osd directory:
  cmd.run:
    - name: chown ceph:ceph {{osd_location}}
    - onlyif: test -d {{osd_location}}
{% endif %}

