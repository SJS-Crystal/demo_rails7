module ErrorHandler
  def self.included(klass)
    return if Rails.env.development?

    klass.class_eval do
      rescue_from StandardError do
        render_response(message: 'Internal Error!', success: false, status: 500)
      end

      rescue_from AccessDenied do
        render_response(message: 'You do not have access!', success: false, status: 403)
      end

      rescue_from ActiveRecord::RecordNotFound do
        render_response(message: 'Not found', success: false, status: 404)
      end

      rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed do |ex|
        render_response(message: ex.record.errors.full_messages, success: false, status: 422)
      end

      rescue_from JWT::DecodeError do
        render_response(message: 'Invalid token', success: false, status: 401)
      end

      rescue_from JWT::ExpiredSignature do
        render_response(message: 'Token expired!', success: false, status: 401)
      end

      rescue_from Pagy::VariableError do |ex|
        render_response(message: ex.message, success: false, status: 401)
      end
    end
  end
end
