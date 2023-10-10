class JwtService
  PRIVATE_KEY = Rails.application.secret_key_base

  def initialize(bearer_token, device_id, device_secret, object_type = nil)
    @with_exception = false
    @bearer_token = bearer_token
    @aud = {device_id: device_id, device_secret: device_secret, object_type: object_type}.to_s
  end

  def authenticate!
    @with_exception = true
    authenticate
  end

  def authenticate
    payload = decoded_token.first
    [true, payload]
  rescue JWT::ExpiredSignature
    handle_error(:expired_token)
  rescue JWT::DecodeError
    handle_error(:invalid_token)
  end

  def self.generate_jwt_token(object_id, device_id, device_secret, object_type = nil)
    exp = (Time.zone.now + Settings.token_life_time.days).to_i
    aud = {device_id: device_id, device_secret: device_secret, object_type: object_type}.to_s
    payload = {object_id: object_id, exp: exp, aud: aud}
    JWT.encode payload, PRIVATE_KEY, 'HS256'
  end

  private

  def decoded_token
    JWT.decode(jwt_token, PRIVATE_KEY, true, aud: @aud, verify_aud: true, algorithm: 'HS256')
  end

  def jwt_token
    pattern = /^Bearer /
    @bearer_token.gsub(pattern, '') if @bearer_token&.match(pattern)
  end

  def handle_error(error_type)
    return [false, nil] unless @with_exception

    case error_type
    when :expired_token
      raise JWT::ExpiredSignature, 'Access token has expired!'
    when :invalid_token
      raise JWT::DecodeError, 'Access token is invalid!'
    end
  end
end
