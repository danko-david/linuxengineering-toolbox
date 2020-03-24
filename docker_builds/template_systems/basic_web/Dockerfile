FROM lxe_basic_server
RUN apt-get -y install mariadb-server-10.3 php7.3 php7.3-mysql php7.3-mysqlnd php7.3-mysqli php7.3-gd php7.3-xsl php7.3-xml php7.3-tidy php7.3-dom php7.3-mbstring php7.3-imagick php7.3-json php7.3-cli php7.3-pdo php7.3-pgsql

# install mysql backup
RUN /opt/linuxengineering-toolbox/installer/install_mysql_backup.sh

# Install phpmyadmin
RUN /opt/linuxengineering-toolbox/installer/install_phpmyadmin.sh


# add services to boot script
RUN bash -c 'echo "service mysql start" >> /container-run.sh'
RUN chmod 755 /container-run.sh

# define boot script
CMD bash -c '/container-run.sh; bash'

