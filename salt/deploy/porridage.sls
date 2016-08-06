ceph_setup:
  salt.state:
    - tgt: 'roles:ceph-deploy'
    - tgt_type: grain
    - sls: ceph.admin

pca_setup:
  salt.state:
    - tgt: 'roles:oat-pca'
    - tgt_type: grain
    - sls: oat.oat-pca
    - require:
      - salt: ceph_setup

oat_server_setup:
  salt.state:
    - tgt: 'roles:oat-server'
    - tgt_type: grain
    - sls: oat.oat-server
    - require:
      - salt: pca_setup

oat_client_setup:
  salt.state:
    - tgt: 'roles:oat-client'
    - tgt_type: grain
    - sls: oat.oat-client
    - require:
      - salt: oat_server_setup

