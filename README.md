# Practica-Arq3capas
Creación de una infraestructura en 3 capas para el despliegue de WordPress
Configuración de montaje de las VPC, subredes e instancias.
1. Crear VPC
Lo primero es crear una VPC con el bloque CIDR IPv4 10.0.0.0/16, que nos permitirá definir el rango de direcciones IP que utilizaremos dentro de la infraestructura.

![image](https://github.com/user-attachments/assets/05845c29-da7f-4087-aa62-6339e504df74)

Descripción: Al crear la VPC, se asigna un rango de IPs privadas que se usarán en las subredes de la infraestructura, asegurando que la red interna sea accesible y esté segmentada correctamente.

2. Crear subredes
Es necesario crear las subredes que alojarán las distintas capas de la infraestructura: pública para el balanceador de carga y privada para los servidores backend y la base de datos.

![image](https://github.com/user-attachments/assets/4aa1fd2d-5c08-4ed6-847a-20e54242a1ae)

Descripción: Cada capa tendrá su propia subred. Las subredes públicas estarán disponibles para el acceso externo, mientras que las subredes privadas estarán aisladas, sin acceso directo desde internet.

3. Crear una puerta de enlace de Internet
Para permitir que las instancias en la capa pública tengan acceso a Internet, se crea una puerta de enlace de Internet.

![image](https://github.com/user-attachments/assets/16ab595e-4e52-4988-bbb4-be2f6cdc6de8)

Descripción: La puerta de enlace se conectará a la tabla de enrutamiento pública, permitiendo que los recursos en esa capa tengan salida a internet, mientras que los recursos de la capa privada no lo tendrán de forma directa.

4. Crear las tablas de enrutamiento
Se crean dos tablas de enrutamiento: una para la subred pública, donde se permite el acceso a Internet, y otra para las subredes privadas, para asegurarse de que sólo el tráfico adecuado fluya entre las capas.

![image](https://github.com/user-attachments/assets/81b9c10e-ba56-4b70-8e30-e6e55f767deb)

Descripción: Las tablas de enrutamiento permiten controlar el tráfico entre las subredes y hacia Internet. La subred pública tendrá una ruta que le permita acceder a Internet, mientras que las privadas no.

5. Agregar una ruta a la tabla pública para que tenga salida a Internet
En la tabla de enrutamiento pública, se agrega una ruta a la puerta de enlace de Internet.

Descripción: Esto asegura que cualquier instancia en la subred pública pueda acceder a Internet, lo cual es esencial para el balanceador de carga y la comunicación con los usuarios finales.

6. Crear los grupos de seguridad
A continuación, creamos los grupos de seguridad para controlar el tráfico hacia y desde las instancias.

Descripción: Los grupos de seguridad permiten gestionar las reglas de acceso a las instancias. Se definen reglas de entrada y salida para asegurar que sólo el tráfico autorizado pueda llegar a los servidores. Las reglas propuestas permiten todo el tráfico para simplificar la configuración inicial, pero se deben afinar para mejorar la seguridad posteriormente.

7. Crear las instancias
Creamos varias instancias de EC2 para cada capa de la infraestructura. Estas instancias se utilizarán para el balanceador de carga, los servidores backend, el servidor NFS y la base de datos.

![image](https://github.com/user-attachments/assets/c1327ede-853d-4e2c-84da-e9ff1b13e013)

a) Instancia para el balanceador
La imagen del sistema operativo será Ubuntu 24.04, y el tipo de instancia será t2.micro. Se creará un par de claves para acceder a la instancia.

![image](https://github.com/user-attachments/assets/0bf4191f-a289-4bf3-82b3-0549bdddd8c0)

Descripción: El balanceador de carga debe ser una instancia pública con acceso a Internet. Esta instancia se configura para distribuir el tráfico entre los servidores backend.

b) Instancia para el servidor Backend 1
Esta instancia actuará como el primer servidor de backend, conectándose al servidor NFS para obtener los recursos de WordPress.

![image](https://github.com/user-attachments/assets/9bc6dd8c-c74b-4dfd-9a47-5f379949e720)

Descripción: El backend 1 tendrá configuraciones similares al balanceador, pero estará en una subred privada para que no tenga acceso directo a Internet.

c) Instancia para el servidor Backend 2
El segundo servidor de backend será configurado de la misma manera que el primero.

![image](https://github.com/user-attachments/assets/e8679c56-7814-48a2-95f9-9df8ff9401be)

Descripción: Tener múltiples servidores backend permite distribuir la carga entre los servidores y hacer el sistema más escalable y tolerante a fallos.

d) Instancia para el NFS
El servidor NFS contendrá todos los recursos compartidos de WordPress y exportará estos recursos a los servidores backend.

![image](https://github.com/user-attachments/assets/6301624b-7bfe-40bb-b2ae-fdcbad8557ab)

Descripción: El servidor NFS actúa como almacenamiento centralizado, lo que permite que todos los servidores web accedan a los mismos archivos de forma consistente.

e) Instancia para el servidor con la base de datos
La base de datos se ejecutará en una instancia privada, asegurándose de que sólo los servidores backend puedan acceder a ella.

![image](https://github.com/user-attachments/assets/3b1b5546-da10-41a2-9078-389616fe89b5)

Descripción: Es importante que la base de datos esté en una subred privada para evitar el acceso no autorizado desde Internet.

8. Crear IP elástica
Asignamos una dirección IP elástica al balanceador de carga para que pueda ser accesible desde cualquier punto de la web.

![image](https://github.com/user-attachments/assets/8f047d5c-b5ea-4ef4-8c77-e4170175f9a2)

Descripción: La IP elástica asegura que el balanceador de carga tenga una dirección IP estática, facilitando el acceso a los usuarios finales.

9. Crear una Gateway NAT
Para permitir que las instancias en las subredes privadas tengan acceso a Internet, se crea una Gateway NAT. Esta gateway debe ser añadida a la tabla de enrutamiento de las subredes privadas.

Descripción: La Gateway NAT permitirá que las instancias privadas accedan a Internet para tareas como la descarga de actualizaciones o la comunicación con servicios externos sin exponerlas directamente a Internet.

10. Eliminar la Gateway NAT de la tabla de enrutamiento de las subredes privadas
Una vez que las instancias privadas estén configuradas correctamente, debemos eliminar la ruta a la Gateway NAT para que no haya tráfico innecesario a través de ella.

Descripción: La eliminación de esta ruta garantiza que el tráfico entre las instancias privadas y la Internet se controle de forma segura, utilizando la arquitectura de red definida.
