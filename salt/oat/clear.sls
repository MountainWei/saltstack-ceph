{% import 'oat/global.jinja' as conf with context %}
{% set roles = grains['roles'] %}

clear /etc/intel:
  cmd.run:
    - name: sudo rm -rf /etc/intel/*
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -d /etc/intel/

clear /opt/intel:
  cmd.run:
    - name: sudo rm -rf /opt/intel/*
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -d /opt/intel/

clear /var/lib/tomcat6/webapps:
  cmd.run:
    - name: sudo rm -rf /var/lib/tomcat6/webapps/*
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -d /var/lib/tomcat6/webapps/

clear /var/lib/tomcat6/logs:
  cmd.run:
    - name: sudo rm -rf /var/lib/tomcat6/logs/*
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -d /var/lib/tomcat6/logs/

{% if 'oat-pca' in roles %}
restore tomcat6 conf file:
  cmd.run:
    - name: sudo sed -i "/8181/d" /var/lib/tomcat6/conf/server.xml
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -f /var/lib/tomcat6/conf/server.xml
{% endif %}

{% if 'oat-server' in roles %}
clear oat directory:
  file.absent:
    - name: /home/{{conf.user}}/.oat

create oat directory:
  file.directory:
    - name: /home/{{conf.user}}/.oat
    - user: {{conf.user}}
    - group: {{conf.user}}
    - dir_mode: 777
    - require:
      - file: clear oat directory
{% endif %}

{% if 'oat-client' in roles %}
clear /etc/init.d/tagent*:
  cmd.run:
    - name: sudo rm -rf /etc/init.d/tagent*
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -f /etc/init.d/tagent*

clear /usr/local/bin/tagent*:
  cmd.run:
    - name: sudo rm -rf /usr/local/bin/tagent*
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -f /usr/local/bin/tagent*

clear /usr/local/bin/pcakey:
  cmd.run:
    - name: sudo rm -r /usr/local/bin/pcakey
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -f /usr/local/bin/pcakey

clear /var/log/tagent*.log
  cmd.run:
    - name: sudo rm -rf /var/log/tagent*.log
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -f /var/log/tagent*.log
{% endif %}
