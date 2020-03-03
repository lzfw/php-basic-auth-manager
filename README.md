# PHP Apache2 Basic Auth Manager

A really simple manager for .htaccess Basic Auth using .htpasswd and .htgroups
files.

Uses the
[PHP Apache2 Basic Auth](https://github.com/rafaelgou/php-apache2-basic-auth)
lib.

![Screenshot](screenshot.png)


## Docker

```
wget -O docker-compose.yaml https://raw.githubusercontent.com/lzfw/php-apache2-basic-auth-manager/master/docker-compose.standalone.yaml
wget -O config.yml https://github.com/lzfw/php-apache2-basic-auth-manager/blob/master/config.yml.dist
docker-compose up -d --no-build

docker-compose exec app bash
htpasswd -cB /var/htsecrets/.htpasswd superuser
chown www-data:www-data /var/htsecrets/.htpasswd

echo 'admin: superuser' > /var/htsecrets/.htgroups
chown www-data:www-data /var/htsecrets/.htgroups
```

## Install

1) Clone the repository under a web:

Considering you have a Apache Web Server running with `DocumentRoot /var/www/web`.
Notes:
* The subdirectory named `web` must be served.
* [Composer must be installed](https://getcomposer.org/download/) and in [`$PATH` (UNIX) or `%PATH%` (Windows)](https://getcomposer.org/doc/00-intro.md).

```bash
cd /var/www
git clone https://github.com/lzfw/php-apache2-basic-auth-manager.git
cd php-apache2-basic-auth-manager
composer install
```

2) Configure the application

```bash
cd php-apache2-basic-auth-manager
cp config.yml.dist config.yml
chown -R www-data:www-data *
```

(or whatever user your webserver is running under).

Edit `config.yml` using your favorite editor, and be sure to point to the
right paths for `.htpasswd`  and `.htgroups` files.

```yml
# Base URL
baseUrl: http://localhost

# Path to Apache2 files
htpasswd: '/var/htsecrets/.htpasswd'
htgroups: '/var/htsecrets/.htgroups'

# Debug
debug: false
```

3) Apache config

The system directory must have:

```apache2
AllowOverride All
```

to permit Basic Auth.

4) Create `.htpasswd` and `.htgroups` files

They can be anywhere, but must be readable by webserver user (e.g. www-data).
You need to create a initial admin user:

```bash
htpasswd -cB /var/htsecrets/.htpasswd superuser
chown www-data:www-data /var/htsecrets/.htpasswd
```



```bash
echo 'admin: superuser' > /var/htsecrets/.htgroups
chown www-data:www-data /var/htsecrets/.htgroups
```

5) Create .htaccess file for the system

```bash
cd php-apache2-basic-auth-manager
```

Edit `.htaccess` using your favorite editor, and put the following content

```apache
AuthName "Members Area"
AuthType Basic
AuthUserFile /var/www/.htpasswd
AuthGroupFile /var/www/.htgroups
require group admin
# or
# require user superuser
```

6) Enable required modules

```
sudo a2enmod authz_core authz_groupfile rewrite
sudo service apache2 reload
```

7) Now you can access

http://localhost

Use the user/password created above.

