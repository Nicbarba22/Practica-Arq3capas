# Refrescamos los repositorios del sistema
sudo apt update -y

# Instalamos el servidor Apache para que funcione como balanceador de carga
sudo apt install apache2 -y

# Instalamos el cliente necesario para conectarnos al servidor NFS
sudo apt install nfs-common -y

# Instalamos PHP y las extensiones requeridas para que WordPress funcione correctamente
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring php-xmlrpc php-zip php-soap php -y

# Creamos una copia del archivo de configuración de Apache para personalizarlo
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/web.conf

# Modificamos el archivo para cambiar el directorio donde se alojarán los archivos de WordPress
sudo sed -i 's|DocumentRoot .*|DocumentRoot /var/nfs/compartir/wordpress|g' /etc/apache2/sites-available/web.conf

# Añadimos permisos para que Apache pueda acceder al directorio de WordPress
sudo sed -i '/<\/VirtualHost>/i \
<Directory /var/nfs/compartir/wordpress>\
    Options Indexes FollowSymLinks\
    AllowOverride All\
    Require all granted\
</Directory>' /etc/apache2/sites-available/web.conf

# Montamos la carpeta compartida del servidor NFS en el directorio local
sudo mount 10.0.2.63:/var/nfs/compartir /var/nfs/compartir

# Desactivamos la configuración predeterminada de Apache
sudo a2dissite 000-default.conf

# Activamos la nueva configuración personalizada para servir WordPress
sudo a2ensite web.conf

# Reiniciamos el servicio de Apache para que los cambios surtan efecto
sudo systemctl restart apache2

# Recargamos la configuración de Apache
sudo systemctl reload apache2

# Configuramos el montaje automático de la carpeta NFS al iniciar el sistema
sudo echo "10.0.2.63:/var/nfs/compartir    /var/nfs/compartir   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | sudo tee -a /etc/fstab
