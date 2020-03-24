#!/bin/bash

TAR_DIR=/opt/phpmyadmin-5.0.2

cd /opt
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
unzip phpMyAdmin-5.0.2-all-languages.zip
rm phpMyAdmin-5.0.2-all-languages.zip
mv phpMyAdmin-5.0.2-all-languages $TAR_DIR
chown www-data:www-data -R $TAR_DIR
chmod 755 -R $TAR_DIR
touch $TAR_DIR/.htpasswd

cat <<EOF > /etc/apache2/conf-available/phpmyadmin.conf

Alias /phpmyadmin $TAR_DIR

<Directory $TAR_DIR>
	Options -Indexes
	AuthType Basic
        AuthName "PhpMyAdmin access"
        AuthUserFile $TAR_DIR/.htpasswd
        Require valid-user
</Directory>

EOF

a2enconf phpmyadmin
