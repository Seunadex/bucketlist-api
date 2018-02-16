class JsonWebToken
  HMAC_SECRET = Rails.applicaition.secrets.secret_key_base

  def slef.encode(payload, exp = 72.hours.from_now)
    payload[:exp] = exp.to_i
    Jwt.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end
