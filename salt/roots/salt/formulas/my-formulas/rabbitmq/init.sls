# TODO: dependency on erlang package is outside this module :(
# TODO: template rabbitmq.config
# TODO: merge this module with formula

include:
  - epel

erlang:
  pkg:
    - installed
    - require:
      - file: enable_epel

install_rabbit_rpm_pubkey:
  cmd.run:
    - name: rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    - unless: rpm -qi  gpg-pubkey | egrep "RabbitMQ"

rabbitmq-server:
  pkg:
    - installed
    - sources:
      - rabbitmq-server: https://www.rabbitmq.com/releases/rabbitmq-server/v3.3.1/rabbitmq-server-3.3.1-1.noarch.rpm
    - require:
      - cmd: install_rabbit_rpm_pubkey
      - pkg: erlang
  service:
    - running
    - enable: True

# TODO: do I have to run this as root?
{% set rabbitmq = pillar.get('rabbitmq', False) %}
{% if rabbitmq %}
{%   set runas = rabbitmq.get('runas', 'rabbitmq') %}
{%   for plugin in rabbitmq.get('plugins',[]) %}
rabbitmq_plugin_{{ plugin }}:
  rabbitmq_plugin.enabled:
    - name: {{ plugin }}
    #- runas: {{ runas }}
    - runas: root
    - require:
      - pkg: rabbitmq-server
{%   endfor %}
{%   for user in rabbitmq.get('rootusers', []) %}
rabbitmq_rootuser_{{ user['name'] }}:
  rabbitmq_user.present:
    - name: {{ user['name'] }}
    {% for option in ('password', 'force', 'tags', 'perms') %}
    {% if user.get(option) %}
    - {{ option }}: {{ user.get(option) }}
    {% endif %}
    {% endfor %}
    - runas: {{ runas }}
{%   endfor %}
{%   for vhost in rabbitmq.get('vhosts', []) %}
rabbitmq_vhost_{{ vhost['name'] }}:
  rabbitmq_vhost.present:
    - name: {{ vhost['name'] }}
    {% for option in ('owner', 'conf', 'write', 'read') %}
    {% if vhost.get(option) %}
    - {{ option }}: {{ vhost.get(option) }}
    {% endif %}
    {% endfor %}
    - runas: {{ runas }}
{%   endfor %}
{%   for user in rabbitmq.get('users', []) %}
rabbitmq_user_{{ user['name'] }}:
  rabbitmq_user.present:
    - name: {{ user['name'] }}
    {% for option in ('password', 'force', 'tags', 'perms') %}
    {% if user.get(option) %}
    - {{ option }}: {{ user.get(option) }}
    {% endif %}
    {% endfor %}
    - runas: {{ runas }}
{%   endfor %}

{%   set absent = rabbitmq.get('absent', False) %}
{%   if absent %}
{%     for plugin in absent.get('plugins',[]) %}
rabbitmq_plugin_{{ plugin }}:
  rabbitmq_plugin.disabled:
    - name: {{ plugin }}
    - runas: {{ runas }}
    - require:
      - pkg: rabbitmq-server
{%     endfor %}
{%     for vhost in absent.get('vhosts', []) %}
rabbitmq_vhost_{{ vhost }}:
  rabbitmq_vhost.absent:
    - name: {{ vhost }}
    - runas: {{ runas }}
{%     endfor %}
{%     for user in absent.get('users', []) %}
rabbitmq_user_{{ user }}:
  rabbitmq_user.absent:
    - name: {{ user }}
    - runas: {{ runas }}
{%     endfor %}
{%  endif %}

{% endif %}
