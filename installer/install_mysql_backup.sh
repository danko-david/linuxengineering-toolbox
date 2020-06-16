#!/bin/sh

mkdir -p /var/backups/mysql_backups/
cd /var/backups/mysql_backups/

cat <<'EOF' > mysql_backup.sh
#!/bin/bash
cd /var/backups/mysql_backups/
mkdir $(date +%Y_%m_%d)

for line in $(mysql --defaults-file=/etc/mysql/debian.cnf -AN -e "show databases");
do
	mysqldump --defaults-file=/etc/mysql/debian.cnf $line > $(date +%Y_%m_%d)/$line.__$(date +%Y_%m_%d).sql ;
	gzip $(date +%Y_%m_%d)/$line.__$(date +%Y_%m_%d).sql
done

EOF

chmod 755 mysql_backup.sh

echo "\n\n# Mysql backups from all the databases\n0 2	* * *	root	/var/backups/mysql_backups/mysql_backup.sh" >> /etc/crontab

