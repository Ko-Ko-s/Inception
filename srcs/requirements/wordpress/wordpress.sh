sleep 10
mkdir -p /run/php/
touch /run/php/php7.3-fpm.pid
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
if [ -e /var/www/html/wp-config.php ]
then
	echo "wp-config already exists"
else
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  cd /var/www/html/
  wp core download --allow-root
  mv ./wp-config.php /var/www/html/
  echo "Configuring Wordpress parameters"
  wp config create --allow-root --path=/var/www/html/ --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --dbprefix=${DB_PREFIX} --skip-check
  echo "Installing Wordpress"
  wp core install --allow-root --path=/var/www/html/ --url=${DB_URL} --title="My Title" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_MAIL}
  echo "Creating additional user ko-ko"
  wp user create --allow-root ${WP_NEW_USER} ${WP_NEW_USE_MAIL} --user_pass=${WP_NEW_USE_PASSWORD}
fi                              
exec "$@"
