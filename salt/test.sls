copy release file:
  file.recurse:
    - name: /home/saltstack/release
    - source: salt://release
    - user: saltstack
    - group: saltstack
    - dir_mode: 755
    - file_mode: 755
    - clean: True
    - include_empty: True

copy jdk1.7: 
  file.recurse:
    - name: /home/saltstack/jdk1.7.0_79
    - source: salt://files/jdk1.7.0_79
    - user: saltstack
    - group: saltstack
    - dir_mode: 755
    - file_mode: 755
    - clean: True
    - include_empty: True

config jdk1.7:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_HOME=$HOME/jdk1.7.0_79
      - export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
      - export PATH=$JAVA_HOME/bin:$PATH

Run onlyif jdk environment changes:
  cmd.wait:
    - name: source /etc/profile
    - runas: saltstack
    - cwd: /home/saltstack/
    - shell: /bin/bash
    - watch:
      - file: config jdk1.7 

clear intel files:
  file.absent:
    - name: /home/saltstack/test_curse/
