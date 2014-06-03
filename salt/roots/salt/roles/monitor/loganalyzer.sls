

######## install loganalyzer

/tmp/loganalyzer-3.6.5.tar.gz:
  file.managed:
    - source: http://download.adiscon.com/loganalyzer/loganalyzer-3.6.5.tar.gz
    - source_hash: sha1=10de09ecb408855a5c699f345f9986271c608dda

/var/www/loganalyzer:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - pkg: php-pear
  cmd.run:
    - name: tar xz --strip=2 -C /var/www/loganalyzer -f /tmp/loganalyzer-3.6.5.tar.gz
    - unless: test -f /var/www/loganalyzer/install.php
    - require:
      - file: /var/www/loganalyzer
      - file: /tmp/loganalyzer-3.6.5.tar.gz

###### PHP dependencies for log analyzer
php-common:
  pkg:
    - installed
    - watch_in:
      - service: php-fpm

php-pear:
  pkg:
    - installed
    - watch_in:
      - service: php-fpm

php-pecl-mongo:
  pkg:
    - installed
    - watch_in:
      - service: php-fpm

php-bcmath:
  pkg:
    - installed
    - watch_in:
      - service: php-fpm

php-gd:
  pkg:
    - installed
    - watch_in:
      - service: php-fpm

# various packages needed for loganalzyer to work properly
# TODO: php needed as well?
# TODO: setup unix socket for php-fpm
php-fpm:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: php-fpm

/var/lib/php/session:
  file.directory:
    - user: apache
    - group: apache
    - mode: 770
    - require:
      - pkg: php-fpm

/etc/php-fpm.d/loganalyzer.conf:
  file.managed:
    - source: salt://monitor/loganalyzer_php-fpm.conf
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: php-fpm
    - watch_in:
      - service: php-fpm

/etc/php-fpm.d/www.conf:
  file.absent:
    - watch_in:
      - service: php-fpm


# TODO: things to set up in php.ini:
#       doc_root ?
#
/etc/php.ini:
  file.sed:
    - before: ^;date.timezone =
    - after: ^date.timezone = Australia/Brisbane
    - require:
      - pkg: php-common
    - watch_in:
      - service: php-fpm
