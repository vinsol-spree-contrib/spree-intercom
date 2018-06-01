class Spree::Intercom::Events::UserSession::LoginService < Spree::Intercom::BaseService

  EVENT_NAME = 'logged-in'

  def initialize(options)
    @user = Spree::User.find_by(id: options[:user_id])
    @time = options[:time]
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
      event_name: EVENT_NAME,
      created_at: @time,
      user_id: @user.intercom_user_id
    }
  end

end
