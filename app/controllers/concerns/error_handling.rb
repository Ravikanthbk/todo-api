module ErrorHandling
  protected
  def record_not_found(exception)
    respond_with_error('not_found', nil, exception.message)
    return
  end

  def invalid_record(exception)
    message = exception.record.errors.full_messages.first
    respond_with_error('unprocessable_entity', nil, message)
    return
  end

  def param_missing(exception)
    message = exception.message
    respond_with_error('parameter_missing', nil, message)
    return
  end

  def action_missing(m, *args, &block)
    Rails.logger.error(m)
    route_not_found
  end

  def route_not_found
    respond_with_error('no_route_found')
    return
  end

  def invalid_pagination(exception)
    message = exception.message
    respond_with_error('internal_server_error', nil, message)
    return
  end

  # def no_method_error(exception)
  #   message = exception.message
  #   respond_with_error('internal_server_error', nil, message)
  # end

  def respond_with_error(error, invalid_resource = nil, exception_msg = nil)
    error = API_ERRORS[error]
    error['details'] = exception_msg unless exception_msg.nil?
    Rails.logger.debug("#{error.inspect}")
    render json: error, status: error['status']
  end
  
end
