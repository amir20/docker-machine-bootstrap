
FROM williamyeh/ansible:alpine3

ENV ANSIBLE_HOST_KEY_CHECKING False

RUN ansible-galaxy install jnv.unattended-upgrades debops.fail2ban

RUN mkdir -p /etc/ansible \
  && mkdir -p /usr/share/ansible_plugins/ \
  && echo 'localhost' > /etc/ansible/hosts

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY lookup_plugins /usr/share/ansible_plugins/lookup_plugins
COPY ./bootstrap.yml /ansible/bootstrap.yml
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
