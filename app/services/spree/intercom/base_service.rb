class Spree::Intercom::BaseService

  class NotImplementedError < StandardError; end

  attr_accessor :response

  def initialize
    @intercom ||= ::Intercom::Client.new(token: Spree::Config.intercom_access_token)
  end

  def send_request
    begin
      intercom_data = perform
      byebug
      
    rescue Intercom::AuthenticationError, Intercom::ServerError, Intercom::ServiceUnavailableError, Intercom::ServiceConnectionError,
           Intercom::ResourceNotFound, Intercom::BlockedUserError, Intercom::BadRequestError, Intercom::RateLimitExceeded,
           Intercom::AttributeNotSetError, Intercom::MultipleMatchingUsersError, Intercom::HttpError, Intercom::IntercomError => e
      intercom_data = e
      byebug

    end

    create_response_object(intercom_data)
  end

  def create_response_object(data)
    byebug
    @response = Spree::Intercom::Response.new(data)
  end

  def perform
    raise NotImplementedError
  end

end
