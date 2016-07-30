nodes:
  minion1:
    roles:
      - ceph-deploy
  minion2:
    roles:
      - ceph-mon
  minion3:
    roles:
      - ceph-osd
  minion4:
    roles:
      - ceph-osd

