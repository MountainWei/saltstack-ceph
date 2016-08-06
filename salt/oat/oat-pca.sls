{% import 'oat/global.jinja' as conf with context %}
{% set ip = conf.pca['ip']  %}

include:
  - .clear

install requirement packages:
  pkg.installed:
    - pkgs:
      - tomcat6
      - mysql-server
      - git
      - maven
      - makeself
      - zip
      - make
      - g++
      - expect

config maven environment:
  file.append:
    - name: /etc/profile
    - text: export MAVEN_OPTS="-Xmx512M -XX:MaxPermSize=512M"
    
Run onlyif maven environment changes:
  cmd.wait:
    - name: source /etc/profile
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}/
    - shell: /bin/bash
    - watch:
      - file: config maven environment 

deploy pca server:
  cmd.run:
    - name: sudo sh deploy_ubuntu_pca.sh --ip {{ip}}
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}/release/deploy
    - onlyif : test -f /home/{{conf.user}}/release/deploy/deploy_ubuntu_pca.sh

change oat files permission:
  cmd.run:
    - name: sudo chmod -R 777 /home/saltstack/.oat
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}
    - onlyif: test -d /home/{{conf.user}}/.oat/
    - require:
      - cmd: deploy pca server

post deploy:
  file.absent:
    - name: /home/{{conf.user}}/release/
    - require:
      - cmd: deploy pca server
