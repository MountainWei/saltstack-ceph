{% set oscodename = salt['config.get']('oscodename') %}
{% set version = salt['pillar.get']('ceph:version') %}

delete exist ceph list:
  file.absent:
    - name: /etc/apt/sources.list.d/ceph.list

ceph_repo:
  pkgrepo.managed:
    - name: deb http://download.ceph.com/debian-{{ version }}/ {{ oscodename }} main
    - file: /etc/apt/sources.list.d/ceph.list
    - key_url: https://download.ceph.com/keys/release.asc
    - require: 
      - file: delete exist ceph list
