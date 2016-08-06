{% import 'oat/global_vars.jinja' as conf with context %}
{% set pca_ip = conf.pca['ip']  %}

include:
  - .clear

install requirement packages:
  pkg.installed:
    - pkgs:
      - make
      - makeself
      - zip
      - g++
      - libtspi-dev

download bcprov-jdk15-1.46.jar from pca:
  cmd.run:
    - name: scp {{conf.user}}@{{pca_ip}}:{{conf.home}}/.m2/repository/org/bouncycastle/bcprov-jdk15/1.46/bcprov-jdk15-1.46.jar {{conf.home}}/jdk1.7.0_79/jre/lib/ext
    - runas: {{conf.user}}
    - cwd: {{conf.home}}
    - unless: test -f {{conf.home}}/jdk1.7.0_79/jre/lib/ext/bcprov-jdk15-1.46.jar 

deploy tagent:
  cmd.run:
    - name: sudo ./TrustAgentLinuxInstaller-2.2.bin
    - runas: {{conf.user}}
    - cwd: {{conf.home}}/release/oat-client

modify the pca ip in conf:
  cmd.run:
    - name: |
       sudo sed -i "/^server.ip=/d" /etc/intel/cloudsecurity/trustagent.properties
       echo "server.ip={{pca_ip}}" | sudo tee -a /etc/intel/cloudsecurity/trustagent.properties
       sudo /usr/local/bin/tagent setup
       sudo /etc/init.d/tagent restart
    - runas: {{conf.user}}
    - cwd: {{conf.home}}
    - require:
      - cmd: deploy tagent

post deploy:
  file.absent:
    - name: {{conf.home}}/release
    - require:
      - cmd: deploy tagent

