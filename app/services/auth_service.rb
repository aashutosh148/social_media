class AuthService
  def self.encode(payload)
    expiration = 24.hours.from_now.to_i
    JWT.encode(payload.merge(exp: expiration), jwt_secret, 'HS256')
  end
  
  def self.decode(token)
    JWT.decode(token, jwt_secret, true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
  
  def self.jwt_secret
    ENV.fetch('JWT_SECRET_KEY') { Rails.application.secret_key_base }
  end
end