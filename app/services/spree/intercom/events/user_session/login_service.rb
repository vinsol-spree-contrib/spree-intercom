class Spree::Intercom::Events::UserSession::LoginService < Spree::Intercom::BaseService

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @options = options
    super()
  end

  def register
    send_request
  end

  def perform
    @intercom.events.create(event_data)
  end

  def event_data
    {
      event_name: 'logged-in',
      created_at: @options[:time],
      user_id: @user.intercom_user_id
    }
  end

end
