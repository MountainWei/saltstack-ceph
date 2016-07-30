{% set oscodename = salt['config.get']('oscodename') %}
{% set version = salt['pillar.get']('ceph:version') %}

ceph_repo:
  pkgrepo.managed:
    - name: deb http://download.ceph.com/debian-{{ version }}/ {{ oscodename }} main
    - file: /etc/apt/sources.list.d/ceph.list
    - key_ur;: https://download.ceph.com/keys/release.asc
