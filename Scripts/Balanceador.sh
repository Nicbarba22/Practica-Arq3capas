# Actualizo los repositorios para evitar errores
apt update -y  

# Instalo Apache para usarlo como servidor proxy
apt install -y apache2  

# Habilito el módulo proxy de Apache
a2enmod proxy  

# Habilito el módulo proxy_http para redirigir peticiones HTTP
a2enmod proxy_http  

# Habilito el módulo de balanceo de carga
a2enmod proxy_balancer  

# Habilito el método de balanceo por número de peticiones
a2enmod lbmethod_byrequests  

# Copio la configuración base para crear una nueva de balanceo
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/load-balanceador.conf  

# Comento la línea del DocumentRoot para no usar el directorio por defecto
sed -i '/DocumentRoot \/var\/www\/html/s/^/#/' /etc/apache2/sites-available/load-balanceador.conf  

# Agrego configuración del clúster con los servidores a balanceador
sed -i '/:warn/ a \<Proxy balancer://mycluster>\n    # Server 1\n    BalancerMember http://10.0.2.153\n    # Server 2\n    BalancerMember http://10.0.2.187\n</Proxy>\n#todas las peticiones las envía al siguiente balanceador\nProxyPass / balancer://mycluster/' /etc/apache2/sites-available/load-balancer.conf  

# Habilito el archivo de configuración del balanceador
a2ensite load-balanceador.conf  

# Deshabilito la configuración por defecto para evitar conflictos
a2dissite 000-default.conf  

# Reinicio Apache para aplicar los cambios
systemctl restart apache2  

# Recargo la configuración de Apache
systemctl reload apache2  
