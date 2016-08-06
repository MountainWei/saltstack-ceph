nodes:
  minion1:
    roles:
      - ceph-deploy
  minion2:
    roles:
      - ceph-mon
      - oat-pca
  minion3:
    roles:
      - ceph-osd
      - oat-server
  minion4:
    roles:
      - ceph-osd
      - oat-client
