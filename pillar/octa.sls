oat:
  release_path: /home/saltstack/.jenkins/workspace/porridge-core/release
  pca:
    host: minion1
    ip: 192.168.86.201
  server:
    minion2:
      ip: 192.168.86.202
      mysql_passwd: 123456
    minion3:
      ip: 192.168.86.203
      mysql_passwd: 123456
  client:
    minion4:
      ip: 192.168.86.204
    
