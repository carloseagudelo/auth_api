Rails.application.routes.draw do
 
 # RUTAS PARA EL MANEJO DE SESIÓN EN EL APLICATIVO
  # Ruta pararealizar el inicio de sesion en el aplicativo
  post 'login', to: 'registration#authenticate_user'
  # Ruta para realizar el primer cambio de contraseña en el aplicativo
  post 'initial_password', to: 'registration#initial_password'
  # Ruta para realizar el cambio de contraseña en el sistema
  post 'reset_passwors', to: 'registration#reset_passwors'
  # Ruta para realizar el cierre de sesion en el aplicativo a nivel de backend
  post 'logout', to: 'registration#logout'
  # Para registrar un candidato
  post 'canditate_registration', to: 'registration#create_user'
  # Para obtener el codigo de recuperación de contraseña
  post 'get_security_code', to: 'registration#set_security_code_change_password'
  
end
