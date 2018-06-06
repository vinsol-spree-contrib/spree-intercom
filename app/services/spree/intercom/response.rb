class Spree::Intercom::Response

  # data maybe be nil in case of successful event request
  def initialize(data)
    @response = data.try(:to_hash)
  end

  def success?
    !failure?
  end

  def failure?
    return false if @response.nil?
    @response['http_code'].present? && @response['http_code'] >= 400  && @response['http_code'] <= 504
  end

  def error_message
    success? ? nil : @response[:message]
  end

  def response
    @response
  end

end
