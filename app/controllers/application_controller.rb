class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  attr_reader :current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_log

  # Cofigura los parametros permitidos para la actualizacion de la informacion de usuario
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password)}
  end

  def initialize_log
    @log = Log.new
    @log.current_user = current_user
  end


 protected
  # Metodo que validad la autenticidad del token guardando la variable de usuario o generando el mensaje de error
  def authenticate_request!
    unless user_id_in_token? # Valida que el token que ingresa tenga el id de usuario
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    if auth_token[:secret] == Constant::CONST_SECRET_PASSWORD_TOKEN
      if User.find(auth_token[:user_id])
        @current_user = User.find(auth_token[:user_id]) # Asigan la informacion del current_user
      else
        render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      end
    else
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

 private

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  # Decodifica el token
  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  # Valida que el token tenga el user_id
  def user_id_in_token? # Metodo que validad la autenticidad del token
    http_token && auth_token && auth_token[:user_id].to_i
  end

end
