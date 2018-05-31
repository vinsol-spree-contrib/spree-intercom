class Spree::Intercom::Response

  def initialize(data)
    @response = data.to_hash
  end

  def success?
    !failure?
  end

  def failure?
    @response['http_code'].present? && @response['http_code'] >= 400  && @response['http_code'] <= 504
  end

  def error_message
    success? ? nil : @response[:message]
  end

  def response
    @response
  end

end
