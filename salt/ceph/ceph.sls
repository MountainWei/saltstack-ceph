{% import 'ceph/global_vars.jinja' as conf with context %}
{% set psls = sls.split('.')[0] %}
{% set host = salt['config.get']('host') -%}
{% set roles = salt['pillar.get']('nodes:' + host + ':roles') -%}

include:
  - .repo

{% if 'ceph-deploy' in roles %}
install ceph-deploy:
  pkg.installed:
    - name: ceph-deploy
    - require:
      - pkgrepo: ceph_repo
{%endif%}

