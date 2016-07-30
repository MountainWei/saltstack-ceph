ceph:
  version: infernalis
  cluster_name: ceph_porridge
  global:
    fsid: 73278717-c98b-4ae5-b21a-6c49e53db7a8
    mon_initial_members: mon1
    mon_host: 10.1.11.12
    auth_cluster_required: cephx
    auth_service_required: cephx
    auth_client_required: cephx
    osd_pool_default_size: 2
  mon:
    interface: eth0
  osd_location:
    osd0: /var/local/osd0/
    osd1: /var/local/osd1/
  cluster:
    monitor:
      - mon1
    osd:
      - osd0
      - osd1
