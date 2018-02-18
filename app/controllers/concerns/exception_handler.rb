module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_error
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_req
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_error
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_error

    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({ message: error.message }, :not_found)
    end
  end

  private

  def unprocessable_error(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def unauthorized_req(e)
    json_response({ message: e.message }, :unauthorized)
  end
end
