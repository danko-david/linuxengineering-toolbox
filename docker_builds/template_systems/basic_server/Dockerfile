FROM lxe_basic

RUN apt-get -y install ssh apache2 munin

WORKDIR /tmp/

# install monit
RUN wget "http://ftp.br.debian.org/debian/pool/main/m/monit/monit_5.20.0-6+deb9u1_amd64.deb"
RUN dpkg -i monit_5.20.0-6+deb9u1_amd64.deb
RUN rm monit_5.20.0-6+deb9u1_amd64.deb

# Configure monit: add monit watch scripts
RUN bash -c 'cp /opt/linuxengineering-toolbox/config/config_samples/monit/{apache,cron,disc,sshd,syslog}.conf /etc/monit/conf.d/'


# Set munin to public
RUN sed -i 's/Require local/Require all granted/g' /etc/apache2/conf-enabled/munin.conf


# add services to boot script
RUN bash -c 'echo "service ssh start" >> /container-run.sh'
RUN bash -c 'echo "service cron start" >> /container-run.sh'
RUN bash -c 'echo "service apache2 start" >> /container-run.sh'
RUN bash -c 'echo "service munin-node start" >> /container-run.sh'
RUN bash -c 'echo "service munin start" >> /container-run.sh'
RUN bash -c 'echo "service monit start" >> /container-run.sh'
RUN chmod 755 /container-run.sh
CMD bash -c '/container-run.sh; bash'
