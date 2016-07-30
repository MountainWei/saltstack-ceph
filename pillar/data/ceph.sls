ceph:
  version: jewel
  cluster_name: ceph_wei
  global:
    fsid: 73278717-c98b-4ae5-b21a-6c49e53db7a8
    mon_initial_members: minion2
    mon_host: 192.168.86.202
    auth_cluster_required: cephx
    auth_service_required: cephx
    auth_client_required: cephx
    osd_pool_default_size: 2
  mon:
    interface: eth0
  osd_location:
    minion3: /var/local/osd0/
    minion4: /var/local/osd1/
  cluster:
    monitor:
      - minion2
    osd:
      - minion3
      - minion4
