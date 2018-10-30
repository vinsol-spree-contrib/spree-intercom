class Spree::Intercom::BaseService

  class NotImplementedError < StandardError; end

  attr_accessor :response

  def initialize
    @intercom ||= ::Intercom::Client.new(token: Spree::Config.intercom_access_token)
  end

  def send_request
    return unless Spree::Config.enable_intercom

    begin
      intercom_data = perform
    rescue Intercom::AuthenticationError, Intercom::ServerError, Intercom::ServiceUnavailableError, Intercom::ServiceConnectionError,
           Intercom::ResourceNotFound, Intercom::BlockedUserError, Intercom::BadRequestError, Intercom::RateLimitExceeded,
           Intercom::AttributeNotSetError, Intercom::MultipleMatchingUsersError, Intercom::HttpError, Intercom::IntercomError => e
      intercom_data = e
    end

    create_response_object(intercom_data)
  end

  def create_response_object(data)
    @response = Spree::Intercom::Response.new(data)
  end

  def perform
    raise NotImplementedError
  end

  private

    def host_name
      Rails.application.routes.default_url_options[:host].presence || "localhost:3000"
    end

    def protocol_name
      Rails.application.routes.default_url_options[:protocol].presence || "http"
    end

    def order_url
      Spree::Core::Engine.routes.url_helpers.order_url(@order, host: host_name, protocol: protocol_name)
    end

end
