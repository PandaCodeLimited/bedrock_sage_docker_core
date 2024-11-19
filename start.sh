cd /var/www/pandacode && composer install
#exec /usr/bin/supervisord -c /etc/supervisord.conf > /dev/null
exec /usr/bin/supervisord -c /etc/supervisord.conf &

# Wait a bit to ensure supervisord has started before continuing
cd /var/www/pandacode/web/app/themes/pandacode && composer install && yarn && yarn dev
