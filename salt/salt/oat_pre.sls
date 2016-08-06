{% import 'oat/global_vars.jinja' as conf with context %}
{% set roles = grains['roles'] %}
{% set oat_roles = [role for role in roles if 'oat' in role] %}
{% set host = grains['host'] %}

{% if oat_roles %}
{% if 'oat-pca' in oat_roles %}
download deploy shell for {{host}}:
  file.managed:
    - name: /home/{{conf.user}}/release/deploy/deploy_ubuntu_pca.sh
    - source: {{conf.release_dir}}/deploy/deploy_ubuntu_pca.sh
    - makedirs: True
    - user: {{conf.user}}
    - group: {{conf.user}}
    - mode: 755

download pca binary files:
  file.recurse:
    - name: /home/{{conf.user}}/release/privacy-ca
    - source: {{conf.release_dir}}/privacy-ca
    - user: {{conf.user}}
    - group: {{conf.user}}
    - dir_mode: 755
    - file_mode: 755
    - clean: True
    - include_empty: True

{% elif 'oat-server' in oat_roles %}
download deploy shell for {{host}}:
  file.managed:
    - name: /home/{{conf.user}}/release/deploy/deploy_ubuntu_server.sh
    - source: {{conf.release_dir}}/deploy/deploy_ubuntu_server.sh
    - makedirs: True
    - user: {{conf.user}}
    - group: {{conf.user}}
    - mode: 755

download zeromq shell:
  file.managed:
    - name: /home/{{conf.user}}/release/deploy/deploy-zeromq.sh
    - source: {{conf.release_dir}}/deploy/deploy-zeromq.sh
    - makedirs: True
    - user: {{conf.user}}
    - group: {{conf.user}}
    - mode: 755
   
download oat server binary files:
  file.recurse:
    - name: /home/{{conf.user}}/release/oat-server
    - source: {{conf.release_dir}}/oat-server
    - user: {{conf.user}}
    - group: {{conf.user}}
    - dir_mode: 755
    - file_mode: 755
    - clean: True
    - include_empty: True  
{% else %}
download oat client binary files:
  file.recurse:
    - name: /home/{{conf.user}}/release/oat-client
    - source: {{conf.release_dir}}/oat-client
    - user: {{conf.user}}
    - group: {{conf.user}}
    - dir_mode: 755
    - file_mode: 755
    - clean: True
    - include_empty: True  
{% endif %}

download jdk1.7: 
  file.recurse:
    - name: /home/{{conf.user}}/jdk1.7.0_79
    - source: salt://files/jdk1.7.0_79
    - user: {{conf.user}}
    - group: {{conf.user}}
    - dir_mode: 755
    - file_mode: 755
    - clean: True
    - include_empty: True

config jdk environments:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_HOME=$HOME/jdk1.7.0_79
      - export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
      - export PATH=$JAVA_HOME/bin:$PATH

Run onlyif jdk environment changes:
  cmd.wait:
    - name: source /etc/profile
    - runas: {{conf.user}}
    - cwd: /home/{{conf.user}}/
    - shell: /bin/bash
    - watch:
      - file: config jdk environments 
{% endif %}
