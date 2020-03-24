FROM debian:buster
RUN apt-get update
RUN apt-get -y install nmap bwm-ng htop links2 screen apt-file strace git nano mc hexedit lsof sudo socat nethogs iotop bsdtar iftop sshfs wget tree rsync mailutils dnsutils tmux curl netcat watch

# copy the lxe-toolbox
COPY . /opt/linuxengineering-toolbox/
## Add maintenace commands
RUN cp /opt/linuxengineering-toolbox/sbin/* /sbin/
RUN cp /opt/linuxengineering-toolbox/bin/* /bin/
## Add install note
RUN echo 'This container build using linuxengineering-toolbox which is copied to /opt/linuxengineering-toolbox/' >> /CONTAINER.NOTE
