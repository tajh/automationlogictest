{% if pillar['nodetype'] == 'nginx' %}
nginx:
     pkg:
       - installed
     service:
       - running
       - watch:
         - pkg: nginx
         - file: /etc/nginx/sites-available/default
/etc/nginx/sites-available/default:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://nginxconf.tmp
    - template: jinja
/root/servicetest.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://servicetest.tmp
    - template: jinja
{% elif pillar['nodetype'] == 'helloworld' %}
nodejs:
  pkg:
    - installed
npm:
  pkg:
    - installed
forever:
  npm.installed: []
/etc/init.d/helloworld:
  file.managed:
    - source: salt://helloworld
    - user: root
    - group: root
    - mode: 755
helloworld:
  service.running:
    - name: helloworld
{% endif %}
addpasswdadmin:
  file.replace:
    - name: /etc/sudoers
    - pattern: "^%admin.*"
    - repl: "%admin   ALL=(ALL:ALL) PASSWD: ALL"
nopasswordvagrant:
  file.replace:
    - name: /etc/sudoers
    - pattern: "^vagrant.*"
    - repl: "vagrant   ALL=(ALL:ALL) NOPASSWD: ALL"
    - append_if_not_found: true
