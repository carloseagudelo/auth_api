class Log < ApplicationRecord


  attr_writer :current_user

  # Metodo que registra en la tabla de logs la tazabilidad de un eror en el sistema
  def registration_error(error, method, functionality, ip)
  	if(!@current_user.nil?)
  	  log = Log.create(user_id: @current_user.id, method: method, functionality: functionality, error: error, ip: ip, log_type: 1)
  	else
  	  log = Log.create(user_id: 0, method: method, functionality: functionality, error: error, ip: ip, log_type: 1)
  	end
  end

  # Metodo que registra en la tabla de logs la tazabilidad del usuario en el sistema
  def registration_auditory(method, functionality, ip)
  	if(!@current_user.nil?)
  	  log = Log.create(user_id: @current_user.id, functionality: functionality, method: method, ip: ip, log_type: 2)
  	else
  	  log = Log.create(user_id: 0, method: method, functionality: functionality, error: error, ip: ip, log_type: 1)
  	end
  end

end
