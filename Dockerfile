
FROM alpine:3.5
MAINTAINER Amir Raminfar <findamir@gmail.com>

ENV ANSIBLE_VERSION 2.2.1.0
ENV ANSIBLE_HOST_KEY_CHECKING False

RUN apk --no-cache add python openssh \    
  && apk add --no-cache --virtual .build-deps python-dev libffi-dev openssl-dev build-base py-pip openssl ca-certificates \
  && pip install --upgrade pip cffi \
  && pip install --no-cache-dir debops ansible==$ANSIBLE_VERSION \    
  && ansible-galaxy install jnv.unattended-upgrades debops.fail2ban \
  && apk del .build-deps 

RUN mkdir -p /etc/ansible \
  && mkdir -p /usr/share/ansible_plugins/ \
  && echo 'localhost' > /etc/ansible/hosts    

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY lookup_plugins /usr/share/ansible_plugins/lookup_plugins
COPY ./bootstrap.yml /ansible/bootstrap.yml
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
