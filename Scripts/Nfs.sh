# Actualizo los repositorios para evitar errores de instalación
apt update -y  

# Instalo el servidor NFS para compartir directorios
apt install nfs-kernel-server -y  

# Instalo unzip para poder descomprimir archivos
apt install unzip -y  

# Instalo curl para descargar archivos desde la terminal
apt install curl -y  

# Instalo PHP y el módulo de MySQL para soportar WordPress
apt install php php-mysql -y  

# Instalo cliente MySQL para conectar con bases de datos externas
apt install mysql-client -y  

# Creo la carpeta compartida donde estarán los archivos de WordPress
mkdir /var/nfs/compartir -p  

# Doy permisos genéricos a la carpeta compartida
chown nobody:nogroup /var/nfs/compartir

# Configuro los permisos de red para que otros equipos accedan al NFS
sed -i '$a /var/nfs/shared   10.0.2.0/24(rw,sync,no_subtree_check)' /etc/exports  

# Descargo la última versión de WordPress
curl -O https://wordpress.org/latest.zip  

# Descomprimo WordPress en la carpeta compartida
unzip -o latest.zip -d /var/nfs/compartir/  

# Configuro los permisos de la carpeta compartida para que sea accesible
chmod 755 -R /var/nfs/compartir/  

# Asigno permisos de Apache a los archivos de WordPress
chown -R www-data:www-data /var/nfs/compartir/*  
