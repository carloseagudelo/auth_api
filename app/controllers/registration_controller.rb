class RegistrationController  < ApplicationController

  respond_to :json
  skip_before_action :verify_authenticity_token

  # Metodo que registra un candidato a la plataforma
  def create_user

    security_code = SecureRandom.hex(4)
    user = User.new(name: params[:name], email: params[:email], password: security_code, password_confirmation: security_code)
    if user.valid?
      if user.save
        # Aplica lo logica necesaria
        #ApplicationMailer.registration_candidate(user, security_code).deliver# notifica el registro por correo
        @log.current_user = user
        @log.registration_auditory(controller_name + '/' + __method__.to_s, Constant::CONST_REGISTER_CANDIDATE, request.remote_ip)
        render json: {status: 200, payload: {message: Constant::CONST_CANDIDATE_REGISTRED, type: Constant::CONST_TYPE_FLASH_MESSAGE_SUCESS}}
      else
        # almacena el error y notifica al administrador del sistema
        #ApplicationMailer.registration_error(@log.registration_error(user.errors.full_messages, controller_name + '/' + __method__.to_s, Constant::CONST_INITIAL_PASSWORD, request.remote_ip)).deliver
        render json: {status: 500, payload: {message: Constant::CONST_INTERNAL_SERVER_ERROR, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
      end
    else
      render json: {status: 400, payload: {message: user.errors.full_messages.first.gsub(user.errors.full_messages.first.split[0]+' ','') , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
    end
  end

  # Asigna un nuevo codigo de verificación para reestablecer contraseña
  def set_security_code_change_password

    if !params[:email].nil? || params[:email] != ''
      user = User.where(email: params[:email]).first
      if !user.nil?
        security_code = SecureRandom.hex(4)
        if user.update(first_passworrd: false, password: security_code, password_confirmation: security_code)
          #ApplicationMailer.set_security_code(user, security_code).deliver # notifica el cambio de contraseña
          @log.current_user = user
          @log.registration_auditory(controller_name + '/' + __method__.to_s, Constant::CONST_GENERATE_SECURITY_CODE, request.remote_ip)
          render json: {status: 200, payload: {message: Constant::CONST_GET_SECURITY_CODE, type: Constant::CONST_TYPE_FLASH_MESSAGE_SUCESS}}
        else
          # almacena el error y notifica al administrador del sistema
          #ApplicationMailer.registration_error(@log.registration_error(user.errors.full_messages, controller_name + '/' + __method__.to_s, Constant::CONST_INITIAL_PASSWORD, request.remote_ip)).deliver
          render json: {status: 500, payload: {message: Constant::CONST_INTERNAL_SERVER_ERROR, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
        end
      else
        render json: {status: 400, payload: {message: Constant::CONST_EMAIL_NO_EXIST , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
      end
    else
      render json: {status: 400, payload: {message: Constant::CONST_EMAIL_NOT_NULL , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
    end
  end

  # Metodo que restablece la contraseña del usuario
  def initial_password

    if !params[:email].nil? || params[:email] != ''
      user = User.where(email: params[:email]).first
      if !user.nil?
        if user.first_passworrd == false
          if user.valid_password?(params[:current_password])
            if params[:password].length >= 8
              if params[:password] == params[:password_confirmation]
                if user.update(password: params[:password], password_confirmation: params[:password_confirmation], first_passworrd: true) # Realiza el cambio de la contraseña
                  # ApplicationMailer.password_changed_notification(user, params[:password]).deliver Notifica el cambio de contraeña
                  @log.current_user = user
                  @log.registration_auditory(controller_name + '/' + __method__.to_s, Constant::CONST_INITIAL_PASSWORD, request.remote_ip)
                  render json: {status: 200, payload: {message: Constant::CONTS_PASSWORD_CHANGE, type: Constant::CONST_TYPE_FLASH_MESSAGE_SUCESS}}
                else
                  # almacena el error y notifica al administrador del sistema
                  #ApplicationMailer.registration_error(@log.registration_error(user.errors.full_messages, controller_name + '/' + __method__.to_s, Constant::CONST_INITIAL_PASSWORD, request.remote_ip)).deliver
                  render json: {status: 500, payload: {message: Constant::CONST_INTERNAL_SERVER_ERROR, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
                end
              else
                render json: {status: 400, payload: {message: Constant::CONST_PASSWORD_NO_MATCH , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
              end
            else
              render json: {status: 400, payload: {message: Constant::CONST_PASSWORD_NO_LENGHT_REQUIRED , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
            end
          else
            render json: {status: 400, payload: {message: Constant::CONST_SECURITY_CODE_DONT_MATCH , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
          end
        else
          render json: {status: 400, payload: {message: Constant::CONST_ALREADY_DONE , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
        end
      else
        render json: {status: 400, payload: {message: Constant::CONST_EMAIL_NO_EXIST , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
      end
    else
      render json: {status: 400, payload: {message: Constant::CONST_EMAIL_NOT_NULL , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
    end
  end

  # Metodo que restablece la contraseña del usuario
  def reset_passwors

    if !params[:email].nil? || params[:email] != ''
      user = User.where(email: params[:email])[0] # Obtiene el usuario que intenta cambiar la contraseña
      if !user.nil?
        if user.valid_password?(params[:current_password]) # Valida si la contraseña que dijito corresponde a la actual
          if params[:password] == params[:password_confirmation]
            if user.update(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation]) # Hace el cambio de contraseña
              # ApplicationMailer.password_changed_notification(user, params[:password]).deliver # notifica el reset de cnraseña
              render json: { status: 200, payload: {message: Constant::CONTS_PASSWORD_CHANGE, type: Constant::CONST_TYPE_FLASH_MESSAGE_SUCESS}}
            else
              # almacena el error y notifica al administrador del sistema
              #ApplicationMailer.registration_error(@log.registration_error(user.errors.full_messages, controller_name + '/' + __method__.to_s, Constant::CONST_INITIAL_PASSWORD, request.remote_ip)).deliver
              render json: {status: 500, payload: {message: Constant::CONST_INTERNAL_SERVER_ERROR, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
            end
          else
            render json: {status: 422, payload: {message: Constant::CONST_PASSWORD_NO_MATCH , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
          end
        else
          render json: {status: 422, payload: {message: Constant::CONTS_NO_CURRENT_PASSWORD, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
        end
      else
        render json: {status: 422, payload: {message: Constant::CONST_EMAIL_NO_EXIST, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
      end
    else
      render json: {status: 422, payload: {message: Constant::CONST_EMAIL_NOT_NULL , type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
    end
  end

  # Metodo que realiza la autenticación del usuario y genera el token de sesion al usuario
  def authenticate_user

    if params[:email] != ''
      if params[:password] != ''
        user = User.find_for_database_authentication(email: params[:email])
        if !user.nil?
          if user.valid_password?(params[:password])
            sign_in(:user, user)
            render json: {status: :authorized, payload: {message: payload(user)}}
          else
            render json: {status: :unauthorized, payload: {message: Constant::CONTS_USER_PASSWORD_INVALID, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR }}
          end
        else
          render json: {status: :unauthorized, payload: {message: Constant::CONST_USER_NO_VALID, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR}}
        end
      else
        render json: {status: :unauthorized, payload: {message: Constant::CONST_NO_PASSWORD, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR }}
      end
    else
      render json: {status: :unauthorized, payload: {message: Constant::CONST_NO_EMAIL, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR }}
    end
  end

  # Metodo que cierra la sesion de usuario
  def logout

    if params[:email] != ''
      user = User.where(email: params[:email]).first
      if user.update(sign_in_count: 0, current_sign_in_at: nil, current_sign_in_ip: nil, role: 0)
        @current_user = nil
        render json: {status: 200, payload: {message: Constant::CONTS_SESION_CLOSE_SUCESS, type: Constant::CONST_TYPE_FLASH_MESSAGE_SUCESS }}
      else
        @log.registration_error(user.errors.full_messages, controller_name + '/' + __method__.to_s, '', request.remote_ip)
        render json: {status: 500, payload: {message: Constant::CONST_INTERNAL_SERVER_ERROR, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR }}
      end
    else
      render json: {status: :unauthorized, payload: {message: Constant::CONST_NO_EMAIL, type: Constant::CONST_TYPE_FLASH_MESSAGE_ERROR }}
    end
  end

 private

  # Metodo que crea el JWT del usuario en base a la informción del usuario
  # Params:
  # user: Objeto de la clase User
  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({ user_id: user.id, date: DateTime.now, email: user.email,
          secret: Constant::CONST_SECRET_PASSWORD_TOKEN, user_name: Personal.where(user_id: user.id).first.name.to_s + " " + Personal.where(user_id: user.id).first.surname.to_s, document_type: Personal.where(user_id: user.id).first.document_type, document_number: Personal.where(user_id: user.id).first.document_number  })

    }
  end

end
