# auth_api

### Sistema de autentificacion (API), usando JSON WEb TOken y Devise.


* **Versión de ruby:** 2.3.0

* **Versión de rails:** 5.0.1

* **Servdor de aplicaciones:** Puma 3.9.1

* **Dependencias:**
    * mysql (Base de datos)
    * devise (Capa de seguridad del aplicativo)
    * jwt (Manejo de la seguridad en la sesion a travez de tokens)
    * rack-cors (Manejo de seguridad en las peticiones)

* **Información de la base de datos de dsllo:**
    * adater: mysql2 (Adaptador de la base de datos)
    * encoding: utf8 (Set de caracteres de la base de datos)
    * username: user_name (Usuario de la base de datos)
    * password: user_password (Contraseña de la base de datos)
    * host: localhost
    * port: 3306 (Puesto en el que se expone la base de datos)
    * database: database_name (Nombre de la base de datos)

* **Antes de correr el proyecto:**
    * $ rake db:create (Crea la base de datos)
    * $ rake db:migrate (Migra las tablas y campos a la base de datos)
    * $ bundle install (Instala las gemas 'lebrerias' utilizadas en la implementación)
    * $ rails s -b (host donde correrta el aplicatico) -p (puerto donde correra el aplicativo) -d (Corre como un proceso en el servidot)

* **Documentación API:**
    Remitase al archivo ** routes.rb ** en la ruta /app/config/routes.rb en este proyecto


* **Lugar:** (Sapiencia) Medellín Colombia
