# Actualizamos los repositorios para asegurarnos de tener las últimas versiones disponibles
sudo apt update -y

# Instalamos el servidor MySQL para gestionar la base de datos
sudo apt install mysql-server -y

# Instalamos phpMyAdmin para administrar MySQL desde un entorno web
sudo apt install -y phpmyadmin

# Configuramos MySQL para que acepte conexiones remotas desde una IP específica
sudo sed -i "s/^bind-address\s*=.*/bind-address = 10.0.3.9/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de MySQL para aplicar los cambios en la configuración
sudo systemctl restart mysql

# Creamos la base de datos, el usuario y asignamos permisos desde MySQL
sudo mysql -u root <<EOF
CREATE DATABASE db_wordpress;               # Creamos la base de datos para WordPress
CREATE USER 'Nicolas'@'10.0.3.9.%' IDENTIFIED BY '1234';  # Añadimos un usuario con permisos limitados a este rango de IPs
GRANT ALL PRIVILEGES ON db_wordpress.* TO 'Nicolas'@'10.0.3.9.%';  # Otorgamos privilegios al usuario sobre la base de datos
FLUSH PRIVILEGES;                           # Aplicamos los cambios realizados
EOF
