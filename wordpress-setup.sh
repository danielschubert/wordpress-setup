#!/bin/bash

domain="set-ur-domain-here"
admin_email="ur-email"

if [[ $# -eq 0 ]] ; then
    echo 'Site name required'
    exit 1
fi

cat > conf/$1.conf << EOL 
<VirtualHost *:80>
  ServerName $1.$domain
  ServerAlias $1.$domain
  DocumentRoot /home/dany/www/$1
  DirectoryIndex index.php index.html
  CustomLog /home/dany/www/log/$1_access.log common
  ErrorLog /home/dany/www/log/$1_error.log
  <Directory /home/dany/www/$1/>
      AllowOverride None
      Order allow,deny
      Allow from all
      Options -Indexes
  </Directory>
</VirtualHost>
EOL

mkdir $1
cd $1
wget https://de.wordpress.org/latest-de_DE.zip
unzip latest-de_DE.zip -d .
mv wordpress/* .
rmdir wordpress 

wp core config --dbname=$1 --dbuser=$1 --dbhost=localhost --dbpass=$1 --skip-check
wp core install --url=$1.$domain --title=$1 --admin_user=admin --admin_password=admin --admin_email=i$admin_email --skip-email

