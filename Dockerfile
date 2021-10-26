FROM php:7.4-apache

ENV GLPI_VERSION=9.5.6

# Install glpi dependencies
RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
        apt-utils \
        gnupg \
        curl \
        libpng-dev \
        libonig-dev \
        libbz2-dev \
        libxml2 \
        libxslt-dev \
        libldb-dev \
        libldap2-dev \
        jq \
        wget
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && curl -sS --insecure https://www.dotdeb.org/dotdeb.gpg | apt-key add -
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev
RUN docker-php-ext-install fileinfo gd json mbstring mysqli session simplexml xml intl ldap xmlrpc zip bz2 exif opcache
# Enable APCU PHP extension
RUN pecl install apcu \
  && docker-php-ext-enable apcu
#Get glpi binaries
RUN wget https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz && \
    tar -xzf glpi-${GLPI_VERSION}.tgz && \
    rm -f glpi-${GLPI_VERSION}.tgz && \
    chown -R www-data:www-data glpi
RUN echo "<VirtualHost *:80>\n\tDocumentRoot /var/www/html/glpi\n\n\t<Directory /var/www/html/glpi>\n\t\tAllowOverride All\n\t\tOrder Allow,Deny\n\t\tAllow from all\n\t</Directory>\n\n\tErrorLog /var/log/apache2/error-glpi.log\n\tLogLevel warn\n\tCustomLog /var/log/apache2/access-glpi.log combined\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf
WORKDIR /var/www/html/glpi
CMD ["/bin/bash","apachectl","-D","FOREGROUND"]
