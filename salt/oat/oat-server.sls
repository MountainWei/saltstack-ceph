{% import 'oat/global_vars.jinja' as conf with context %}
{% set pca_ip = conf.pca['ip']  %}
{% set host = grains['host'] %}
{% set mysql_passwd = conf.server[host]['mysql_passwd'] %}

include:
  - .clear

install require packages:
  pkg.installed:
    -pkgs: 
      - tomcat6
      - mysql-server
      - git
      - maven
      - makeself
      - zip
      - make 
      - g++
      - python-mysqldb
      - expect

config maven environment:
  file.append:
    - name: /etc/profile
    - text: export MAVEN_OPTS="-Xmx512M -XX:MaxPermSize=512M -Djava.library.path=/usr/local/lib"
    
Run onlyif maven environment changes:
  cmd.wait:
    - name: source /etc/profile
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}/
    - shell: /bin/bash
    - watch:
      - file: config maven environment 

copy oat directory from pca:
  cmd.run:
    - name: scp -r {{conf.user}}@{{pca_ip}}:/home/{{conf.user}}/.oat/* /home/{{conf.user}}/.oat
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - require:
      - file: create oat directory

deploy zeromq:
  cmd.run:
    - name: sudo sh deploy-zeromq.sh
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}/release/deploy
    - unless: sudo test -f /usr/local/lib/*jzmq.so*

deploy oat server:
  cmd.run:
    - name: sudo sh deploy_ubuntu_server.sh --mysql {{mysql_passwd}} --ip {{pca_ip}}
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}/release/deploy
    - onlyif: find -f /home/{{conf.user}}/release/deploy/deploy_ubuntu_server.sh

post deploy:
  file.absent:
    - name: /home/{{conf.user}}/release
    - require:
      - cmd: deploy oat server
